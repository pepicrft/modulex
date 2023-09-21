defmodule Test do
  use Application.Module

  defimplementation do
    def foo() do
      "foo"
    end
  end

  defbehaviour do
    @callback foo() :: String.t()
    @callback say_hello(name :: String.t()) :: none()
  end
end
