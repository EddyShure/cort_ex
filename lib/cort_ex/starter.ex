defmodule CortEx.Neuron.Starter do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    send(self(), :start_children)
    {:ok, nil}
  end

  def handle_info(:start_children, _) do
    neuron_id = System.unique_integer([:positive, :monotonic])
    nn = [{:neuron, neuron_id, %{weights: [0.0, 0.0]}},
          {:sensor, System.unique_integer([:positive, :monotonic]), %{node_id: neuron_id}},
          {:actuator, System.unique_integer([:positive, :monotonic]), %{node_id: neuron_id}}]

    Enum.each(nn, fn neuron ->
      CortEx.Neuron.Supervisor.start_child(neuron)
    end)

    {:stop, :normal, nil}
  end
end
