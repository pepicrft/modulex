defmodule ApplicationModuleTest do
  use ExUnit.Case

  defmodule Test do
    use Application.Module

    defimplementation do
      def test() do
        "test"
      end
    end

    defbehaviour do
      @callback test() :: String.t()
    end
  end

  defmodule Mock do
  end

  test "Test.test() returns test" do
    assert Test.test() == "test"
  end

  test "Test.mock_module() returns the right module" do
    assert Test.mock_module() == __MODULE__.Test.Mock
  end

  test "Test.implementation_module() returns the right module" do
    assert Test.implementation_module() == __MODULE__.Test.Implementation
  end

  test "Test.behaviour_module() returns the right module" do
    assert Test.behaviour_module() == __MODULE__.Test.Behaviour
  end

  test "Test.get_application_env_module() returns the right module" do
    assert Test.get_application_env_module() == __MODULE__.Test.Implementation
  end

  test "Test.get_application_env_module() returns the right module when the implementation is changed" do
    module = __MODULE__.Test.get_application_env_module()
    __MODULE__.Test.put_application_env_module(__MODULE__.Mock)

    assert Test.get_application_env_module() == __MODULE__.Mock
    # Note: This prevents asynchronous tests from working.
    __MODULE__.Test.put_application_env_module(module)
  end
end
