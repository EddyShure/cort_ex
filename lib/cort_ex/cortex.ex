defmodule CortEx.Cortex do
  use GenServer
  require Logger
  
  def start_link(id, [input, neuron, output]) do
    Logger.debug("Starting cortex ##{id}")
    GenServer.start_link(__MODULE__, [input, neuron, output], name: via_tuple(id))
  end

  defp via_tuple(neuron_id), do: {:via, Registry, {CortEx.NeuronRegistry, neuron_id}}

  def init(brain) do
    {:ok, brain}
  end

  def sense_think_act(id) do
    GenServer.cast(via_tuple(id), :sense_think_act)
  end

  def handle_cast(:sense_think_act, state) do
    state |> hd() |> CortEx.Sensor.sync()
    {:noreply, state}
  end
end
