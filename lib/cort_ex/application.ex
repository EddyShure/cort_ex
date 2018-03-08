defmodule CortEx.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Registry, [:unique, CortEx.NeuronRegistry]),
      supervisor(CortEx.SimpleNeuralNet, []),
      #supervisor(CortEx.Neuron.Starter, [], restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: CortEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
