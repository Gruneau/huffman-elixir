defmodule Huffman do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text()  do
    'this is something that we should encode'
  end

  def test do
    encoded_table = sample()
      |> tree
      |> encode_table
    text = text()
    seq = encode(text, encoded_table)
    decode(seq, encoded_table)
  end

  defp tree(sample) do
    sample 
    |> freq 
    |> Enum.to_list
    |> Enum.map(fn({a,b}) -> {b,a} end)
    |> Enum.sort
    |> build_tree
  end

  defp build_tree([]), do: []
  defp build_tree([{f1,c1},{f2,c2}|t]) do
    [{f1+f2,{c1,c2}}|t]
    |> Enum.sort
    |> build_tree
  end
  defp build_tree(tree), do: tree

  defp freq(sample) do
    freq(sample, %{})
  end
  
  defp freq([], map) do
    map
  end
  
  defp freq([char | rest], map) do
    case map[char] do
      nil   -> 
        freq(rest, Map.put(map, char, 1))
      count -> 
        freq(rest, Map.put(map, char, (count+1)))
    end
  end

  defp encode_table([top]) do
    {count, root} = top
    encode_t(root,[])
  end
  defp encode_t({left,right}, path) do
    encode_t(left, [0|path]) ++ encode_t(right, [1|path])
  end
  defp encode_t(leaf, path) do 
    [{leaf, Enum.reverse(path)}]
  end

  def encode([], table), do: []
  def encode([char|rest], table) do
    {char, sequence} = List.keyfind(table, char, 0)
    sequence ++ encode(rest,table)
  end

  def decode([], _), do: []
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end
  
  defp decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, rem} ->
        {char, rest};
      nil ->
        decode_char(seq, n+1, table)
    end
  end

end