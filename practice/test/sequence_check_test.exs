defmodule SequenceCheckTest do
  use ExUnit.Case
  import SequenceCheck

  test "greets the world" do
    assert validate("123") == 1
    assert validate("321") == :error
    assert validate("19202122") == 19
    assert validate("2122232") == :error
    assert validate("312313314") == 312
    assert validate("123123122") == :error
    assert validate("99100") == 99
    assert validate("10100") == :error
    assert validate("0123") == :error
  end
end
