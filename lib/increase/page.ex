defmodule Increase.Page do
  @moduledoc """
  Represents a single page of results from a list endpoint, along with
  enough information to fetch subsequent pages.

  Every `list/2` function in a resource module (e.g. `Increase.Accounts.list/2`)
  returns `{:ok, %Increase.Page{}}`. Use `auto_paging_each/2` or
  `auto_paging_stream/1` to walk every page without manually managing the
  cursor.

  ## Examples

      {:ok, page} = Increase.Accounts.list(client, limit: 100)
      page.data        #=> [%{"id" => "account_...", ...}, ...]
      page.next_cursor #=> "v57w5d" | nil

      # Lazily stream every Account across every page:
      Increase.Page.auto_paging_stream(page)
      |> Stream.each(&IO.inspect/1)
      |> Stream.run()
  """

  defstruct data: [],
            next_cursor: nil,
            fetch_next: nil

  @type t :: %__MODULE__{
          data: [term()],
          next_cursor: String.t() | nil,
          fetch_next: (String.t() -> {:ok, t()} | {:error, Increase.Error.t()})
        }

  @doc false
  @spec new(
          map(),
          (String.t() -> {:ok, t()} | {:error, Increase.Error.t()}),
          (map() -> struct()) | nil
        ) :: t()
  def new(raw, fetch_next, decoder \\ nil)

  def new(%{"data" => data, "next_cursor" => next_cursor}, fetch_next, nil) do
    %__MODULE__{data: data, next_cursor: next_cursor, fetch_next: fetch_next}
  end

  def new(%{"data" => data, "next_cursor" => next_cursor}, fetch_next, decoder)
      when is_function(decoder, 1) do
    %__MODULE__{data: Enum.map(data, decoder), next_cursor: next_cursor, fetch_next: fetch_next}
  end

  @doc """
  Returns `true` if there is another page of results after this one.
  """
  @spec has_next?(t()) :: boolean()
  def has_next?(%__MODULE__{next_cursor: nil}), do: false
  def has_next?(%__MODULE__{}), do: true

  @doc """
  Fetches the next page of results. Returns `{:error, :no_more_pages}` if
  this is already the last page.
  """
  @spec next_page(t()) :: {:ok, t()} | {:error, :no_more_pages | Increase.Error.t()}
  def next_page(%__MODULE__{next_cursor: nil}), do: {:error, :no_more_pages}

  def next_page(%__MODULE__{next_cursor: cursor, fetch_next: fetch_next}) do
    fetch_next.(cursor)
  end

  @doc """
  Returns a lazy `Stream` of every individual item across this page and
  all subsequent pages, fetching new pages on demand as the stream is
  consumed.

      Increase.Accounts.list(client)
      |> case do
        {:ok, page} -> Increase.Page.auto_paging_stream(page)
        {:error, error} -> raise error
      end
      |> Enum.take(250)
  """
  @spec auto_paging_stream(t()) :: Enumerable.t()
  def auto_paging_stream(%__MODULE__{} = page) do
    Stream.resource(
      fn -> {page.data, page} end,
      &next_item/1,
      fn _ -> :ok end
    )
  end

  defp next_item({[item | rest], page}), do: {[item], {rest, page}}

  defp next_item({[], page}) do
    if has_next?(page) do
      case next_page(page) do
        {:ok, %__MODULE__{data: data} = new_page} -> next_item({data, new_page})
        {:error, _} -> {:halt, page}
      end
    else
      {:halt, page}
    end
  end

  @doc """
  Calls `fun` once for every item across this page and all subsequent
  pages. Stops early and returns `{:error, error}` if fetching a later
  page fails.
  """
  @spec auto_paging_each(t(), (term() -> any())) :: :ok | {:error, Increase.Error.t()}
  def auto_paging_each(%__MODULE__{} = page, fun) when is_function(fun, 1) do
    Enum.each(page.data, fun)

    if has_next?(page) do
      case next_page(page) do
        {:ok, next} -> auto_paging_each(next, fun)
        {:error, error} -> {:error, error}
      end
    else
      :ok
    end
  end
end
