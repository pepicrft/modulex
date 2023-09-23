# `modulex`

The Application Module serves as a utility library designed to facilitate the creation of modules that conform to a specific behavior. Additionally, it allows for the behavior implementation to be managed through the application's configuration settings. This library is particularly useful when paired with testing libraries like [Mox](https://github.com/dashbitco/mox) or [Hammox](https://github.com/msz/hammox), as it helps eliminate the boilerplate code often required to retrieve the module ID from the application environment.

The following is an exampmle of an application module:

```elixir
defmodule MyApplication.Module do
  use Modulex

  defbehaviour do
    @callback say_hello(name :: String.t()) :: String.t()
  end

  defimplementation do
    def say_hello(name) do
      "Hello, #{name}!"
    end
  end
end
```

`Modulex` implements each of the behaviour functions in `MyApplication.Module`. Unless overriden by the application's configuration `[:my_application, :modules, :module]`, the functions will delegate the execution to the implementations in the module `MyApplication.Module.Implementation`, which is automatically generated by `Modulex` with the body of the `defimplementation` block.

When used in companion with a mocking library like Mox, you can easily mock the module's implementation in your tests:

```elixir
// test_helper.exs

Mox.defmock(MyApplication.Module.mock_module(), for: MyApplication.Module.behaviour_module())
MyApplication.Module.put_application_env_module(MyApplication.Module.mock_module())
```

> **Important:** We strongly recommend the definition of the mocks and the updating of the application environment with them as part of `test_helpers.exs` or any other module that runs before tests start running in parallel. Because the application environment is a global state, updating it from tests might cause unexpected behaviours that are hard to debug.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `modulex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:modulex, "~> 0.7.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/modulex>.

