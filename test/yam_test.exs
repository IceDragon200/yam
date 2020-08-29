defmodule YamTest do
  use ExUnit.Case

  describe "encode/1" do
    test "can encode an atom" do
      assert {:ok, "null"} == Yam.encode(nil)
      assert {:ok, "true"} == Yam.encode(true)
      assert {:ok, "false"} == Yam.encode(false)
      assert {:ok, "hello"} == Yam.encode(:hello)
    end

    test "can encode an integer" do
      assert {:ok, "1"} == Yam.encode(1)
    end

    test "can encode a float" do
      assert {:ok, "46.34"} == Yam.encode(46.34)
    end

    test "can encode a string" do
      assert {:ok, "\"Hello, World\""} == Yam.encode("Hello, World")
    end

    test "can encode an empty list" do
      assert {:ok, "[]"} == Yam.encode([])
    end

    test "can encode an empty map" do
      assert {:ok, "{}"} == Yam.encode(%{})
    end

    test "can encode a decimal" do
      assert {:ok, "\"0\""} == Yam.encode(Decimal.new(0))
      assert {:ok, "\"12.4763\""} == Yam.encode(Decimal.new("12.4763"))
    end

    test "can encode a map" do
      assert """
      a: "Hello"
      b: 2
      c:
      - 1
      - 2
      - 3
      d: 12.43
      e: "445.323"
      """ == Yam.encode!(%{a: "Hello", b: 2, c: [1, 2, 3], d: 12.43, e: Decimal.new("445.323")}) <> "\n"
    end
  end
end
