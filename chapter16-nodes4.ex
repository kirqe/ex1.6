# At first I wanted to use 2 links to previous and next item.
# But then I figured out that I can use one link to the next item
# just like in a one directional linked list.
# Too sad it took me a few days to realize this :O
# It was interesting though.

# There're 2 globally registered processes :origin and :leader.
# The :origin is the first process and it always stays the same.
# But the :leader is updated as soon as someone connects to the ring.

# The ticker process in this chapter is a central server that sends events to
# registered clients. Reimplement this as a ring of clients.
# A client sends a tick to the next client in the ring.
# After 2 seconds, that client sends a tick to its next client.

# first node
# iex> c("ring.ex")
# iex> Ticker.connect

# other nodes
# iex> c("ring.ex")
# iex> Node.connect(:one@mac)
# iex> Ticker.connect

defmodule Ticker do
  @interval 3000 # 3 seconds instead of 2

  def connect do
    case globally_exists?(:origin) do
      {:yes, origin_pid} ->
        case globally_exists?(:leader) do
          {:yes, leader_pid} ->
            pid = spawn(__MODULE__, :receiver, [origin_pid])
            :global.unregister_name(:leader)
            :global.register_name(:leader, pid)
            send leader_pid, {:add, pid}
          {:no} ->
            pid = spawn(__MODULE__, :receiver, [origin_pid])
            :global.register_name(:leader, pid)
            send origin_pid, {:add, pid}
        end
      {:no} ->
        pid = spawn(__MODULE__, :receiver, [nil])
        :global.register_name(:origin, pid)
        send pid, {:add, pid}
    end
  end

  def receiver(next) do
    receive do
      {:add, pid} ->
        IO.puts "connected #{inspect pid}"
        receiver(pid)
      {:tick} ->
        IO.puts "TOCK"
        receiver(next)
      after
        @interval ->
          unless next == nil do
            IO.puts "#{inspect next} sending TICK"
            send(next, {:tick})
            receiver(next)
          end
          receiver(next)
    end
  end

  defp globally_exists?(name) do
    case :global.whereis_name(name) do
      name_pid when is_pid(name_pid) ->
        {:yes, name_pid}
      undefined when is_atom(undefined) ->
        {:no}
    end
  end
end
