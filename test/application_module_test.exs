defmodule ApplicationModuleTest do
  use ExUnit.Case

  test "foo" do
    dbg(TestModule.__info__(:functions))
    assert true == true
  end
end
