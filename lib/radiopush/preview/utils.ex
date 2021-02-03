defmodule Radiopush.Preview.Utils do
  def get_document(url) do
    url
    |> get_url()
    |> parse_document()
  end

  def get_url(url) do
    case http_client().get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        body

      {:error, %{reason: reason}} ->
        {:error, reason}
    end
  end

  def parse_document(body) do
    Floki.parse_document(body)
  end

  defp http_client do
    Application.get_env(:radiopush, :http_client)
  end
end
