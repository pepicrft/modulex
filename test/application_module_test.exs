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
    module = Application.get_env(:application, :modules, %{})[:application_module_test][:test]
    Application.put_env(:application, :modules, [application_module_test: [test: __MODULE__.Mock]])
    assert Test.get_application_env_module() == __MODULE__.Mock
    # Note: This prevents asynchronous tests from working.
    Application.put_env(:application, :modules, [application_module_test: [test: module]])
  end
end
