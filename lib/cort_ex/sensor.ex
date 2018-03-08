defmodule CortEx.Sensor do
  use GenServer
  require Logger

  def start_link(id, outputs) do
    Logger.debug("Starting sensor ##{id}")
    GenServer.start_link(__MODULE__, outputs, name: via_tuple(id))
  end

  defp via_tuple(neuron_id), do: {:via, Registry, {CortEx.NeuronRegistry, neuron_id}}
  
  def init(outputs) do
    {:ok, %{output_ids: outputs}}
  end

  def sync(id) do
    Logger.debug("Sensing")
    GenServer.cast(via_tuple(id), :sync)
  end

  def handle_cast(:sync, state) do
    sensory_signal = [:rand.uniform() - 0.5, :rand.uniform() - 0.5]
    Logger.debug("Signal from the environment: #{inspect sensory_signal}")
    CortEx.Neuron.signal(hd(state.output_ids), sensory_signal)
    {:noreply, state}
  end
end
