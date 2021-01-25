defmodule Radiopush.Preview do
  @spec get_metadata(String.t()) :: any
  def get_metadata(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, document} = Floki.parse_document(body)

        Floki.find(document, "[property='og:title']")
        |> Enum.at(0)
        |> Enum.at(1)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
