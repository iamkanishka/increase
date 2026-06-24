defmodule Increase.PageTest do
  use ExUnit.Case, async: true

  alias Increase.Page

  describe "has_next?/1" do
    test "false when next_cursor is nil" do
      page = %Page{data: [1, 2], next_cursor: nil}
      refute Page.has_next?(page)
    end

    test "true when next_cursor is present" do
      page = %Page{data: [1, 2], next_cursor: "abc"}
      assert Page.has_next?(page)
    end
  end

  describe "next_page/1" do
    test "returns {:error, :no_more_pages} on the last page" do
      page = %Page{data: [1], next_cursor: nil}
      assert {:error, :no_more_pages} = Page.next_page(page)
    end

    test "calls fetch_next with the cursor" do
      page = %Page{
        data: [1],
        next_cursor: "cursor_2",
        fetch_next: fn cursor -> {:ok, %Page{data: [cursor], next_cursor: nil}} end
      }

      assert {:ok, %Page{data: ["cursor_2"]}} = Page.next_page(page)
    end
  end

  describe "auto_paging_stream/1" do
    test "yields every item across a single page" do
      page = %Page{data: [1, 2, 3], next_cursor: nil}
      assert Page.auto_paging_stream(page) |> Enum.to_list() == [1, 2, 3]
    end

    test "fetches subsequent pages lazily and concatenates all items" do
      # Simulates three pages of two items each, then exhaustion.
      fetch = fn
        "page2" ->
          {:ok,
           %Page{
             data: [3, 4],
             next_cursor: "page3",
             fetch_next: fn "page3" -> {:ok, %Page{data: [5, 6], next_cursor: nil}} end
           }}
      end

      first_page = %Page{data: [1, 2], next_cursor: "page2", fetch_next: fetch}

      assert Page.auto_paging_stream(first_page) |> Enum.to_list() == [1, 2, 3, 4, 5, 6]
    end

    test "stops cleanly if a later page fails to fetch" do
      fetch = fn "page2" -> {:error, %Increase.Error{title: "boom"}} end
      first_page = %Page{data: [1, 2], next_cursor: "page2", fetch_next: fetch}

      # Items already retrieved are still yielded; the stream just halts
      # rather than raising, since Stream.resource/3 expects {:halt, acc}.
      assert Page.auto_paging_stream(first_page) |> Enum.to_list() == [1, 2]
    end

    test "supports Enum.take/2 without fetching pages beyond what's needed" do
      {:ok, counter} = Agent.start_link(fn -> 0 end)

      fetch = fn _cursor ->
        Agent.update(counter, &(&1 + 1))
        {:ok, %Page{data: [:x, :y], next_cursor: nil}}
      end

      page = %Page{data: [:a, :b], next_cursor: "first", fetch_next: fetch}

      result = Page.auto_paging_stream(page) |> Enum.take(3)

      assert result == [:a, :b, :x]
      assert Agent.get(counter, & &1) == 1
    end
  end

  describe "auto_paging_each/2" do
    test "calls the function once per item across all pages" do
      fetch = fn "page2" -> {:ok, %Page{data: [3], next_cursor: nil}} end
      page = %Page{data: [1, 2], next_cursor: "page2", fetch_next: fetch}

      {:ok, agent} = Agent.start_link(fn -> [] end)

      assert :ok =
               Page.auto_paging_each(page, fn item ->
                 Agent.update(agent, &[item | &1])
               end)

      assert Agent.get(agent, &Enum.reverse/1) == [1, 2, 3]
    end

    test "propagates an error from a later page" do
      fetch = fn "page2" -> {:error, %Increase.Error{title: "boom"}} end
      page = %Page{data: [1], next_cursor: "page2", fetch_next: fetch}

      assert {:error, %Increase.Error{title: "boom"}} =
               Page.auto_paging_each(page, fn _ -> :ok end)
    end
  end
end
