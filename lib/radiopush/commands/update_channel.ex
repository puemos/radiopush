defmodule Radiopush.Cmd.UpdateChannel do
  defmodule Cmd do
    use TypedStruct

    typedstruct do
      field :channel_id, String.t(), enforce: true
      field :description, String.t()
      field :private, boolean()
    end
  end

  alias Radiopush.Context
  alias Radiopush.Channels

  defp prepare_attrs(%Cmd{} = cmd) do
    %{
      description: cmd.description,
      private: cmd.private
    }
  end

  def run(%Context{} = ctx, %Cmd{} = cmd) do
    owner_id = ctx.user.id

    with {:ok, %{owner_id: ^owner_id} = channel} <-
           Channels.get_channel(cmd.channel_id),
         {:ok, channel} <-
           Channels.update_channel(channel, prepare_attrs(cmd)) do
      {:ok, channel}
    else
      {:ok, %{owner_id: _}} -> {:error, "Unauthorized"}
      {:error, error} -> {:error, error}
    end
  end
end
