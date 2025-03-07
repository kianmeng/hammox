defmodule Hammox.ProtectTest do
  alias Hammox.Test.Protect, as: ProtectTest

  use ExUnit.Case, async: true

  use Hammox.Protect, module: ProtectTest.BehaviourImplementation

  use Hammox.Protect,
    module: ProtectTest.Implementation,
    behaviour: ProtectTest.Behaviour,
    funs: [behaviour_wrong_typespec: 0]

  test "using Protect without module throws an exception" do
    module_string = """
    defmodule ProtectWithoutModule do
      use Hammox.Protect
    end
    """

    assert_raise ArgumentError, ~r/Please specify :module to protect/, fn ->
      Code.compile_string(module_string)
    end
  end

  test "using Protect on a module without callbacks throws an exception" do
    module_string = """
    defmodule ProtectNoCallbacks do
      use Hammox.Protect, module: Hammox.Test.Protect.Implementation
    end
    """

    assert_raise ArgumentError,
                 ~r/The module Hammox.Test.Protect.Implementation does not contain any callbacks./,
                 fn ->
                   Code.compile_string(module_string)
                 end
  end

  test "using Protect on a behaviour without callbacks throws an exception" do
    module_string = """
    defmodule ProtectNoCallbacks do
      use Hammox.Protect, module: Hammox.Test.Protect.Implementation, behaviour: Hammox.Test.Protect.EmptyBehaviour
    end
    """

    assert_raise ArgumentError,
                 ~r/The module Hammox.Test.Protect.EmptyBehaviour does not contain any callbacks./,
                 fn ->
                   Code.compile_string(module_string)
                 end
  end

  test "using Protect creates protected versions of functions from given behaviour-implementation module" do
    assert_raise Hammox.TypeMatchError, fn -> behaviour_implementation_wrong_typespec() end
  end

  test "using Protect creates protected versions of functions from given behaviour and implementation" do
    assert_raise Hammox.TypeMatchError, fn -> behaviour_wrong_typespec() end
  end
end
