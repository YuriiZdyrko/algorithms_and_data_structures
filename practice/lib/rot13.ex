defmodule Rot13 do
  def rot13(string) do
    abc_list = to_list("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    string_list = to_list(string)

    # Mapping in format %{"A" => 0, "B" => 1, ...}
    char_to_index =
      abc_list
      |> Enum.with_index()
      |> Enum.into(%{})

    # Mapping in format %{0 => "A", 1 => "B", ...}
    index_to_char =
      char_to_index
      |> Enum.map(fn {s, i} -> {i, s} end)
      |> Enum.into(%{})

    string_list
    |> Enum.map(fn char ->
      case rot_char_index(char, char_to_index) do
        nil -> char
        index -> index_to_char[index]
      end
    end)
    |> Enum.join()
  end

  @doc "Upper-case char"
  defp rot_char_index(<<v::utf8>> = char, char_to_index) when v in 65..90 do
    case char_to_index[char] + 13 do
      pos when pos > 26 -> pos - 26
      pos -> pos
    end
  end

  @doc "Lower-case char"
  defp rot_char_index(<<v::utf8>> = char, char_to_index) when v in 97..122 do
    case char_to_index[char] + 13 do
      pos when pos > 51 -> pos - 26
      pos -> pos
    end
  end

  @doc "Other char"
  defp rot_char_index(symbol_or_space, _), do: nil

  defp to_list(s), do: String.split(s, "", trim: true)
end

# End smart solution, without need for additional lookup Maps and math
defmodule Encryptor do
  def rot13([]), do: ""

  def rot13([letter | next]) when letter in 65..77 or letter in 97..109,
    do: <<letter + 13>> <> rot13(next)

  def rot13([letter | next]) when letter in 78..90 or letter in 110..122,
    do: <<letter - 13>> <> rot13(next)

  def rot13([letter | next]), do: <<letter>> <> rot13(next)

  def rot13(string), do: rot13(String.to_char_list(string))
end
