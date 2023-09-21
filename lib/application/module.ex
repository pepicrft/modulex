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
        @moduledoc """
        Implements the behaviour for the module that contains this behaviour.
        """
        unquote(block)
      end
    end
  end

  defmacro defimplementation(do: block) do
    quote do
      defmodule Implementation do
        @moduledoc """
        Contains the implementation for the module that contains this module.
        """
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

      unquote(__MODULE__).Macros.functions()
      unquote(__MODULE__).Macros.ensure_module_loaded!(@behaviour_module)
      unquote(__MODULE__).Macros.ensure_module_loaded!(@implementation_module)
      unquote(__MODULE__).Macros.define_behaviour_functions(unquote(env))
    end
  end
end
