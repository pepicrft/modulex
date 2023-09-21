defmodule Application.Module.NestedKeywordList do
  @moduledoc """
  This module provides utilities to generate nested keyword lists.
  """
  @spec generate_nested_keyword_list([atom()], any()) :: keyword()
  def generate_nested_keyword_list(keys, value) do
    generate_nested_keyword_list(keys, value, [])
  end

  defp generate_nested_keyword_list([], value, acc), do: Enum.reverse([value | acc])
  defp generate_nested_keyword_list([key | rest], value, acc) do
    new_value = [{key, generate_nested_keyword_list(rest, value, [])}]
    generate_nested_keyword_list([], new_value, acc)
  end
end
