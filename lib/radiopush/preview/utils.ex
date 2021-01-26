defmodule Radiopush.Preview.Utils do
  def get_document(url) do
    case HTTPoison.get(url, [], recv_timeout: 10000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Floki.parse_document(body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
