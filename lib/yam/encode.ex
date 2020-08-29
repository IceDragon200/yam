defmodule Yam.Encode do
  def encode(item, options) when is_atom(item) do
    atom(item, options)
  end

  def encode(item, options) when is_binary(item) do
    string(item, options)
  end

  def encode(item, options) when is_integer(item) do
    integer(item, options)
  end

  def encode(item, options) when is_float(item) do
    float(item, options)
  end

  def encode(item, options) when is_list(item) do
    list(item, options)
  end

  def encode(%{__struct__: _module} = item, options) do
    Yam.Encoder.encode(item, options)
  end

  def encode(item, options) when is_map(item) do
    map(item, options)
  end

  def atom(nil, _options) do
    "null"
  end

  def atom(item, _options) do
    Atom.to_string(item)
  end

  def integer(item, _options) do
    Integer.to_string(item)
  end

  def float(item, _options) do
    Float.to_string(item)
  end

  def string(item, _options) do
    if String.contains?(item, "\n") do
      # multiline
      [
        "|-\n",
        item
        |> String.split("\n")
        |> Enum.map(fn row ->
          # TODO: allow customizing the indentation
          ["  ", row]
        end)
        |> Enum.intersperse("\n")
      ]
    else
      [
        "\"",
        item
        |> String.replace("\"", "\\\""),
        "\"",
      ]
    end
  end

  def map(map, options) do
    if Enum.empty?(map) do
      "{}"
    else
      Enum.map(map, fn {key, value} when is_integer(key) or is_binary(key) or is_atom(key) ->
        key_iodata = encode(key, options)
        value_iodata = encode(value, options)

        [
          key_iodata, ":",
          case value do
            [] ->
              [" ", value_iodata]

            list when is_list(list) ->
              ["\n", value_iodata]

            map when is_map(map) ->
              str = IO.iodata_to_binary(value_iodata)
              if String.contains?(str, "\n") do
                [
                  "\n",
                  str
                  |> String.split("\n")
                  |> Enum.map(fn row ->
                    ["  ", row]
                  end)
                  |> Enum.intersperse("\n"),
                ]
              else
                [" ", str]
              end

            _ ->
              [" ", value_iodata]
          end,
        ]
      end)
      |> Enum.intersperse("\n")
    end
  end

  def list([], _options) do
    "[]"
  end

  def list(list, options) do
    Enum.map(list, fn item ->
      iodata = encode(item, options)
      result = IO.iodata_to_binary(iodata)

      [line1 | rest] =
        result
        |> String.split("\n")

      rest =
        Enum.map(rest, fn row ->
          ["  ", row]
        end)

      [
        ["- ", line1]
        | rest
      ]
      |> Enum.intersperse("\n")
    end)
    |> Enum.intersperse("\n")
  end
end
