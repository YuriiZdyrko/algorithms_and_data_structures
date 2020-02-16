defmodule SequenceCheck do
  @failed_check :error
  @success_check :ok

  def validate(string) do
    init_check(string, 1)
  end

  @doc """
  Run check/2 with incremented "start" lengths
  "120120" =>
      check("120120", 1)
      check("120120", 12)
      check("120120", 120)
      ...
  """
  def init_check("0" <> _rest = string, _), do: @failed_check

  def init_check(string, start_length) when byte_size(string) / 2 < start_length,
    do: @failed_check

  def init_check(string, start_length) do
    with <<start::binary-size(start_length)>> <> _ <- string,
         {start, _} <- Integer.parse(start),
         @success_check <- check(string, start) do
      start
    else
      _ -> init_check(string, start_length + 1)
    end
  end

  @doc """
  Check if string contains ordered numbers, 
  counting from "start" parameter
  """
  def check("", _), do: @success_check

  def check(string, start) do
    start_str = Integer.to_string(start)

    with true <- String.starts_with?(string, start_str) do
      check(String.trim_leading(string, start_str), start + 1)
    end
  end
end
