defmodule Application.Module do
  @type t() :: module()

  defmacro __using__(_opts \\ []) do
    quote do
      @before_compile unquote(__MODULE__)
      require unquote(__MODULE__).Macros
      import unquote(__MODULE__)
    end
  end

  defmacro defbehaviour(do: block) do
    quote do
      defmodule Behaviour do
        unquote(block)
      end
    end
  end

  defmacro defimplementation(do: block) do
    quote do
      defmodule Implementation do
        @behaviour Module.split(__MODULE__) |> List.replace_at(-1, :Behaviour) |> Module.concat

        unquote(block)
      end
    end
  end

  defmacro __before_compile__(env) do
    quote location: :keep do
      @implementation_module __MODULE__.Implementation
      @behaviour_module __MODULE__.Behaviour
      @mock_module __MODULE__.Mock
      @behaviour @behaviour_module

      def mock_module() do
        @mock_module
      end

      def implementation_module() do
        @implementation_module
      end

      def behaviour_module() do
        @behaviour_module
      end

      unquote(__MODULE__).Macros.application_env_module_function()
      unquote(__MODULE__).Macros.ensure_module_loaded!(@behaviour_module)
      unquote(__MODULE__).Macros.ensure_module_loaded!(@implementation_module)
      unquote(__MODULE__).Macros.define_behaviour_functions(unquote(env))
    end
  end
end
