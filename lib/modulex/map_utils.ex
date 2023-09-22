defmodule Modulex.MapUtils do
  @moduledoc """
  A set of utilities to work with maps
  """
  @spec put_deep(map :: map(), keys :: [atom()], value :: term()) :: map()
  def put_deep(map, [key], value), do: Map.put(map, key, value)

  def put_deep(map, [key | rest_keys], value) do
    child_map = Map.get(map, key, %{})
    updated_child_map = put_deep(child_map, rest_keys, value)
    Map.put(map, key, updated_child_map)
  end
end
