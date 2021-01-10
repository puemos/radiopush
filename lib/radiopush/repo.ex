defmodule Radiopush.Repo do
  use Ecto.Repo,
    otp_app: :radiopush,
    adapter: Ecto.Adapters.Postgres
end
