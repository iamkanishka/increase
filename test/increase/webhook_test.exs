defmodule Increase.WebhookTest do
  use ExUnit.Case, async: true

  alias Increase.Webhook

  # This fixture's signature was computed independently in Python
  # (hmac/hashlib, not Elixir) against the exact algorithm described in
  # Increase's docs, to verify against real ground truth rather than just
  # round-tripping through compute_signature/4 itself:
  #
  #   signed_payload = f"{id}.{timestamp}.{body}"
  #   mac = hmac.new(secret.encode(), signed_payload.encode(), hashlib.sha256).digest()
  #   signature = "v1," + base64.b64encode(mac).decode()
  @id "evt_test_123"
  @timestamp "1700000000"
  @body ~s({"id":"evt_test_123","type":"event"})
  @secret "whsec_test_secret"
  @expected_signature "v1,15yrhxYkHPhPnuqbHblHUhO3b6HMKkUAj5L7JVZox7c="

  defp headers(overrides \\ %{}) do
    Map.merge(
      %{
        "webhook-id" => @id,
        "webhook-timestamp" => @timestamp,
        "webhook-signature" => @expected_signature
      },
      overrides
    )
  end

  describe "compute_signature/4" do
    test "matches an independently-computed HMAC-SHA256 fixture" do
      assert Webhook.compute_signature(@id, @timestamp, @body, @secret) == @expected_signature
    end

    test "changes if any input changes" do
      base = Webhook.compute_signature(@id, @timestamp, @body, @secret)

      assert Webhook.compute_signature("different_id", @timestamp, @body, @secret) != base
      assert Webhook.compute_signature(@id, "1700000001", @body, @secret) != base
      assert Webhook.compute_signature(@id, @timestamp, "different body", @secret) != base
      assert Webhook.compute_signature(@id, @timestamp, @body, "different_secret") != base
    end
  end

  describe "verify/4" do
    test "returns :ok for a genuinely valid signature, with tolerance disabled" do
      assert Webhook.verify(@body, headers(), @secret, tolerance: false) == :ok
    end

    test "returns {:error, :signature_mismatch} when the body was tampered with" do
      assert Webhook.verify("tampered body", headers(), @secret, tolerance: false) ==
               {:error, :signature_mismatch}
    end

    test "returns {:error, :signature_mismatch} when the secret is wrong" do
      assert Webhook.verify(@body, headers(), "wrong_secret", tolerance: false) ==
               {:error, :signature_mismatch}
    end

    test "returns {:error, :signature_mismatch} when the id was tampered with" do
      assert Webhook.verify(@body, headers(%{"webhook-id" => "evt_attacker_controlled"}), @secret,
               tolerance: false
             ) == {:error, :signature_mismatch}
    end

    test "returns {:error, :missing_headers} when any required header is absent" do
      assert Webhook.verify(@body, %{}, @secret) == {:error, :missing_headers}

      assert Webhook.verify(@body, headers(%{"webhook-id" => nil}), @secret) ==
               {:error, :missing_headers}
    end

    test "validates against multiple space-separated signatures (secret rotation)" do
      other_signature = Webhook.compute_signature(@id, @timestamp, @body, "other_secret")
      combined = "#{other_signature} #{@expected_signature}"

      assert Webhook.verify(@body, headers(%{"webhook-signature" => combined}), @secret,
               tolerance: false
             ) == :ok
    end

    test "fails when none of several space-separated signatures match" do
      sig_a = Webhook.compute_signature(@id, @timestamp, @body, "secret_a")
      sig_b = Webhook.compute_signature(@id, @timestamp, @body, "secret_b")
      combined = "#{sig_a} #{sig_b}"

      assert Webhook.verify(@body, headers(%{"webhook-signature" => combined}), @secret,
               tolerance: false
             ) == {:error, :signature_mismatch}
    end

    test "accepts a timestamp within the default tolerance window" do
      now = System.system_time(:second)
      id = "evt_now"
      ts = Integer.to_string(now)
      body = "{}"
      sig = Webhook.compute_signature(id, ts, body, @secret)

      headers = %{"webhook-id" => id, "webhook-timestamp" => ts, "webhook-signature" => sig}

      assert Webhook.verify(body, headers, @secret) == :ok
    end

    test "rejects a timestamp outside the default tolerance window (replay protection)" do
      old = System.system_time(:second) - 1000
      id = "evt_old"
      ts = Integer.to_string(old)
      body = "{}"
      sig = Webhook.compute_signature(id, ts, body, @secret)

      headers = %{"webhook-id" => id, "webhook-timestamp" => ts, "webhook-signature" => sig}

      assert Webhook.verify(body, headers, @secret) == {:error, :timestamp_out_of_tolerance}
    end

    test "accepts a custom :tolerance window" do
      old = System.system_time(:second) - 1000
      id = "evt_old"
      ts = Integer.to_string(old)
      body = "{}"
      sig = Webhook.compute_signature(id, ts, body, @secret)

      headers = %{"webhook-id" => id, "webhook-timestamp" => ts, "webhook-signature" => sig}

      assert Webhook.verify(body, headers, @secret, tolerance: 2000) == :ok
    end

    test "returns {:error, :invalid_timestamp} for a non-integer timestamp" do
      assert Webhook.verify(@body, headers(%{"webhook-timestamp" => "not-a-number"}), @secret) ==
               {:error, :invalid_timestamp}
    end
  end
end
