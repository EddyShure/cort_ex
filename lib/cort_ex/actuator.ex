defmodule CortEx.Actuator do
  use GenServer
  require Logger

  def start_link(id, inputs) do
    Logger.debug("Starting actuator ##{id}")
    GenServer.start_link(__MODULE__, inputs, name: via_tuple(id))
  end

  defp via_tuple(neuron_id), do: {:via, Registry, {CortEx.NeuronRegistry, neuron_id}}

  def init(inputs) do
    {:ok, %{input_ids: inputs}}
  end

  def act(id, signal) do
    GenServer.call(via_tuple(id), {:act, signal})
  end

  def handle_call({:act, signal}, state, _from) do
    Logger.debug("WOW! #{inspect signal}")
    {:noreply, state}
  end
end
