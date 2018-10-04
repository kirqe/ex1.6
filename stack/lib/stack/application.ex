defmodule Stack.Application do
  use Application

  def start(_type, args) do
    children = [
      {Stack.Stash, args},
      {Stack.Server, []}
    ]

    opts = [strategy: :rest_for_one, name: Stack.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
