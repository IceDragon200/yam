defmodule Yam do
  @moduledoc """
  Yam is a YAML encoder library.

  Is it done to spec?

  Likely no, I'm doing it based on memory with using ruby's yaml.
  """
  defmodule EncodeError do
    defexception [:message, :reason]
  end

  @type encode_opt :: {:return, :iodata | :binary}

  @spec encode(term, [encode_opt]) :: {:ok, iodata} | {:error, term}
  def encode(item, options \\ []) do
    value = Yam.Encode.encode(item, Keyword.drop(options, [:return]))

    case Keyword.get(options, :return, :binary) do
      :iodata ->
        {:ok, value}

      :binary ->
        {:ok, IO.iodata_to_binary(value)}
    end
  end

  @spec encode!(term, Keyword.t()) :: iodata
  def encode!(item, options \\ []) do
    case encode(item, options) do
      {:ok, result} ->
        result

      {:error, reason} ->
        raise %EncodeError{message: "encoding item failued", reason: reason}
    end
  end
end
