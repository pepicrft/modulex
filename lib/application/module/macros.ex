defmodule Application.Module.Macros do
  def ensure_module_loaded!(module) do
    unless Code.ensure_loaded?(module) do
      raise "The module #{inspect(module)} is absent."
    end
  end

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

      def get_application_env_module() do
        [_ | keys] = Module.split(__MODULE__) |> Enum.map(&String.to_atom/1)

        application_module =
          case keys do
            [] -> nil
            keys -> Application.get_env(:application, :modules, %{}) |> get_in(keys)
          end

        case application_module do
          nil -> @implementation_module
          module -> module
        end
      end
    end
  end

  defmacro define_behaviour_functions(env) do
    function_definitions =
      Module.concat(env.module, :Behaviour).behaviour_info(:callbacks)
      |> Enum.map(fn {fun, arity} ->
        args = 0..arity |> Enum.to_list() |> tl() |> Enum.map(&Macro.var(:"arg#{&1}", Elixir))
        {fun, args}
      end)
      |> Enum.map(fn {fun, args} ->
        quote do
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
