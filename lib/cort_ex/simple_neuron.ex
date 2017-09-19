defmodule CortEx.SimpleNeuron do
  use Agent
  import Logger

  def create do
    start_link()
  end

  def start_link do
    weights = [nil, nil, nil] |> Enum.map(fn(_) -> :rand.uniform() - 0.5 end)
    Agent.start_link(fn -> weights end, name: __MODULE__)
  end

  defp dot_product([], [], product), do: product
  defp dot_product([], [bias], product), do: product + bias
  defp dot_product([h1|t1], [h2|t2], product) do
    dot_product(t1, t2, product+h1*h2)
  end

  def sense(signal) do
    case is_list(signal) && (length(signal) == 2) do
      true ->
        Logger.debug("Processing signal #{inspect(signal)}")
        weights = Agent.get(__MODULE__, fn state -> state end)
        Logger.debug("Weights: #{inspect(weights)}")
        product = dot_product(signal, weights, 0)
        output = :math.tanh(product)
        Logger.debug("Output: #{output}")
      false ->
        Logger.error("The signal must be a [x, x]")
    end
  end
end
