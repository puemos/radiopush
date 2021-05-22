defmodule Radiopush.Infra.PageMetadata do
  @moduledoc false

  @type opaque_cursor :: String.t()

  @type t :: %__MODULE__{
          after: opaque_cursor() | nil,
          before: opaque_cursor() | nil,
          limit: integer(),
          total_count: integer() | nil,
          total_count_cap_exceeded: boolean() | nil
        }

  defstruct [:after, :before, :limit, :total_count, :total_count_cap_exceeded]

  def new(item) do
    %__MODULE__{
      after: item.after,
      before: item.before,
      limit: item.limit,
      total_count: item.total_count,
      total_count_cap_exceeded: item.total_count_cap_exceeded
    }
  end
end
