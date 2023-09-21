defmodule Application.Module do
  @type t() :: module()

  defmacro __using__(_opts \\ []) do
    quote do
      @before_compile unquote(__MODULE__)
      require unquote(__MODULE__).Macros
      import unquote(__MODULE__)
    end
  end

  defmacro defbehaviour(block) do
    quote do
      defmodule Behaviour do
        unquote(block)
      end
    end
  end

  defmacro defimplementation(block) do
    quote do
      defmodule Impl do
        @behaviour Module.split(__MODULE__) |> List.replace_at(-1, :Behaviour) |> Module.concat

        unquote(block)
      end
    end
  end

  defmacro __before_compile__(env) do
    quote location: :keep do
      @implementation_module __MODULE__.Impl
      @behaviour_module __MODULE__.Behaviour
      @behaviour @behaviour_module

      unquote(__MODULE__).Macros.application_env_module_function()
      unquote(__MODULE__).Macros.ensure_behaviour_presence!()
      unquote(__MODULE__).Macros.ensure_implementation_presence!()
      unquote(__MODULE__).Macros.define_behaviour_functions(unquote(env))
    end
  end
end