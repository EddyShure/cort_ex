defmodule CortEx.Neuron do
  use GenServer
  require Logger

  def start_link(id, [weights, input, output]) do
    Logger.debug("Starting neuron ##{id}")
    GenServer.start_link(__MODULE__, [weights, input, output], name: via_tuple(id))
  end
  
  defp via_tuple(neuron_id), do: {:via, Registry, {CortEx.NeuronRegistry, neuron_id}}

  def init([weights, input, output]) do
    #weights = [:rand.uniform() - 0.5, :rand.uniform() - 0.5]
    #bias = [:rand.uniform() - 0.5]
    {:ok, %{weights: weights, input: input, output: output}}
  end

  defp dot_product([], [], product), do: product
  defp dot_product([], [bias], product), do: product + bias
  defp dot_product([h1|t1], [h2|t2], product) do
    dot_product(t1, t2, product+h1*h2)
  end

  def signal(id, signal) do
    GenServer.cast(via_tuple(id), {:think, signal})
  end

  def handle_cast({:think, signal}, state) do
    Logger.debug("Thinking")
    Logger.debug("Input: #{inspect signal}")
    Logger.debug("Weights: #{inspect state.weights}")

    dot = dot_product(signal, state.weights, 0)
    output = :math.tanh(dot)

    CortEx.Actuator.act(state.output, output)

    {:noreply, state}
  end
end
