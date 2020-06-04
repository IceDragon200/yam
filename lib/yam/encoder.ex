defprotocol Yam.Encoder do
  @moduledoc """
  Where all the voodoo happens
  """
  @type t :: term

  @fallback_to_any true

  @spec encode(t, Keyword.t()) :: iodata
  def encode(item, options)
end

defimpl Yam.Encoder, for: Any do
  def encode(item, _options) do
    # Stolen from Jason
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: item,
      description: """
      Yam.Encoder protocol must always be explicitly implemented.
      """
  end
end

defimpl Yam.Encoder, for: Atom do
  def encode(item, options) do
    Yam.Encode.atom(item, options)
  end
end

defimpl Yam.Encoder, for: Integer do
  def encode(item, options) do
    Yam.Encode.integer(item, options)
  end
end

defimpl Yam.Encoder, for: Float do
  def encode(item, options) do
    Yam.Encode.float(item, options)
  end
end

defimpl Yam.Encoder, for: BitString do
  def encode(item, options) do
    Yam.Encode.string(item, options)
  end
end

defimpl Yam.Encoder, for: [Date, Time, NaiveDateTime, DateTime] do
  def encode(value, _options) do
    [?\", @for.to_iso8601(value), ?\"]
  end
end

defimpl Yam.Encoder, for: Decimal do
  def encode(decimal, _options) do
    [?\", Decimal.to_string(decimal, :normal), ?\"]
  end
end

defimpl Yam.Encoder, for: Map do
  def encode(map, options) do
    Yam.Encode.map(map, options)
  end
end

defimpl Yam.Encoder, for: List do
  def encode(list, options) do
    Yam.Encode.list(list, options)
  end
end
