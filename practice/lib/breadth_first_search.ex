defmodule BFS do
  # def run do
  #     graph = %{}
  #     graph["you"] = ["alice", "bob", "claire"] 
  #     graph["bob"] = ["anuj", "peggy"] 
  #     graph["alice"] = ["peggy"] 
  #     graph["claire"] = ["thom", "jonny"] 
  #     graph["anuj"] = []
  #     graph["peggy"] = []
  #     graph["thom"] = []
  #     graph["jonny"] = []

  #     graph
  #     |> Map.to_list
  #     |> Enum.each(fn {key, val} -> 
  #         shortest_to_anuj(graph, [val])
  #     end)
  # end

  # defp shortest_to_anuj(graph, history) do
  #     graph
  #     |> Enum.each(fn {k, v} -> 
  #         if (v == "anuj") do
  #             IO.inspect(history)
  #         end

  #         shortest_to_anuj(v, history ++ [v])
  #     end)
  # end
end
