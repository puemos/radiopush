defmodule Radiopush.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Radiopush.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Radiopush.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Radiopush.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Radiopush.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Radiopush.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  defdelegate letters_list(from \\ "A", count), to: DirectIteration, as: :list
end

defmodule DirectIteration do
  @moduledoc false
  def list(from \\ "A", count) when is_binary(from) and is_integer(count) and count >= 0 do
    char = :binary.at(from, 0)
    len = byte_size(from)
    build_list(char, len, count)
  end

  defp build_list(_char, _len, 0), do: []

  defp build_list(?z, len, count) do
    [String.duplicate(<<?z>>, len) | build_list(?a, len + 1, count - 1)]
  end


  defp build_list(?Z, len, count) do
    [String.duplicate(<<?Z>>, len) | build_list(?A, len + 1, count - 1)]
  end

  defp build_list(char, len, count) do
    [String.duplicate(<<char>>, len) | build_list(char + 1, len, count - 1)]
  end
end
