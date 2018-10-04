defmodule Stack.Server do
  use GenServer

  @vsn "0"

  #API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def list do
    with current_list = GenServer.call(__MODULE__, :show),
    do: "The current list is: #{inspect current_list}"
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def add(new_item) do
    GenServer.cast(__MODULE__, {:push, new_item})
  end

  def stop do
    GenServer.cast(__MODULE__, :stop)
  end


  #IMPL
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, Stack.Stash.get() }
  end

  def handle_call(:show, _from, list) do
    {:reply, list, list}
  end

  def handle_call(:pop, _from, list) do
    [h|t] = list
    {:reply, h, t}
  end

  def handle_cast({:push, item}, list) do
    {:noreply, [item|list]}
  end

  def handle_cast(:stop, list) do
    {:stop, :normal, list}
  end

  def handle_info({:EXIT, _from, reason}, state) do
    {:stop, reason, state} # see GenServer docs for other return types
  end

  def terminate(reason, state) do
    Stack.Stash.update(state)
    IO.puts "stopping #{inspect reason}"
  end
end
