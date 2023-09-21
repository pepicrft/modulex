defmodule Application.Module.Macros do
  defmacro ensure_behaviour_presence!() do
    quote do
      if !Code.ensure_loaded?(@behaviour_module) do
        raise "The module #{inspect(@behaviour_module)} is absent."
      end

      if !function_exported?(@behaviour_module, :behaviour_info, 1) do
        raise "The module #{inspect(@behaviour_module)} is not a behaviour. Ensure it includes callbacks."
      end
    end
  end

  defmacro ensure_implementation_presence!() do
    quote do
      if !Code.ensure_loaded?(@implementation_module) do
        raise "The module #{inspect(@implementation_module)} is absent."
      end
    end
  end

  defmacro application_env_module_function() do
    quote do
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
