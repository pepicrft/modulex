defmodule Test do
  use Application.Module

  defimplementation do
    def foo() do
      "foo"
    end

    def say_hello(name) do
      IO.puts("Hello #{name}")
    end
  end

  defbehaviour do
    @callback foo() :: String.t()
    @callback say_hello(name :: String.t()) :: any()
  end
end
