defmodule Modulex.Macros do
  @moduledoc """
  This module contains all the macros privately used by the `Modulex` module.
  Because we don't want these macros to be user-facing when users do `use Modulex`,
  we extract them into a different module.
  """

  @doc """
  This macro ensures the given module has been loaded.
  """
  @spec ensure_module_loaded!(module :: module()) :: any()
  def ensure_module_loaded!(module) do
    unless Code.ensure_loaded?(module) do
      raise "The module #{inspect(module)} is absent."
    end
  end

  @doc """
  This macro returns an AST containing a set of utility functions
  that need to be incorporated into the module that uses the `Modulex` module.

  ## Functions

  - `mock_module/0`: Returns the mock module.
  - `implementation_module/0`: Returns the implementation module.
  - `behaviour_module/0`: Returns the behaviour module.
  - `get_application_env_module/0`: Returns the module that has been set in the environment (if any).
  """
  @spec functions() :: any()
  # credo:disable-for-next-line
  defmacro functions() do
    quote do
      def mock_module() do
        @mock_module
      end

      def implementation_module() do
        @implementation_module
      end

      def behaviour_module() do
        @behaviour_module
      end

      defp application_env_keys do
        Module.split(__MODULE__) |> Enum.map(&Macro.underscore/1) |> Enum.map(&String.to_atom/1)
      end

      def put_application_env_module(module) do
        env = Application.get_env(:application, :module, %{})
        env = env |> Modulex.MapUtils.put_deep(application_env_keys(), module)
        Application.put_env(:application, :module, env)
      end

      def get_application_env_module() do
        case Application.get_env(:application, :module, %{}) |> get_in(application_env_keys()) do
          nil -> @implementation_module
          module -> module
        end
      end
    end
  end

  @doc """
  This macro returns an AST that defines the functions that are defined in the behaviour module.
  """
  @spec define_behaviour_functions(env :: Macro.Env.t()) :: any()
  defmacro define_behaviour_functions(env) do
    function_definitions =
      Module.concat(env.module, :Behaviour).behaviour_info(:callbacks)
      |> Enum.map(fn {fun, arity} ->
        args = 0..arity |> Enum.to_list() |> tl() |> Enum.map(&Macro.var(:"arg#{&1}", Elixir))
        {fun, args}
      end)
      |> Enum.map(fn {fun, args} ->
        quote do
          @impl true
          def unquote(fun)(unquote_splicing(args)) do
            get_application_env_module().unquote(fun)(unquote_splicing(args))
          end
        end
      end)

    quote do
      (unquote_splicing(function_definitions))
    end
  end
end
