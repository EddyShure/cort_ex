defmodule CortEx.SimpleNeuralNet do
  use Supervisor
  require Logger

  def start_link do
    Logger.debug("Starting NN")
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_child(type) do
    Supervisor.start_child(__MODULE__, [type])
  end

  def init(_) do
    weights = [:rand.uniform() - 0.5, :rand.uniform() - 0.5]
    bias = :rand.uniform() - 0.5
    
    children = [
      worker(CortEx.Neuron, [1, [weights, 2, 3]]),
      worker(CortEx.Sensor, [2, [1]]),
      worker(CortEx.Actuator, [3, [1]]),
      worker(CortEx.Cortex, [4, [2,1,3]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
