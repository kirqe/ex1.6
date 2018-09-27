# Not sure if this is the correct way of doing this.
# Took quite a long of time to figure out what to do :(
#
# Alter the code so that successive ticks are sent to each registered client (so
# the first goes to the first client, the second to the next client, and so on).
# Once the last client receives a tick, the process starts back at the first.
# The solution should deal with new clients being added at any time.
#
# Server
# iex> iex --sname one
# iex> c("ticker.ex")
# iex> Ticker.start
#
# Client
# iex> c("ticker.ex")
# iex> Node.connect(:one@mac)
# iex> Client.start

defmodule Ticker do
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 0])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients, current) do
    num_of_clients = length(clients)

    IO.puts "current index: #{inspect current}"
    receive do
      {:register, pid} ->
        IO.puts "connected #{inspect pid}"
        current =
          if num_of_clients == 0,
          do: current,
        else: current + 1

        generator([pid | clients], current)
      after
        @interval ->
          IO.puts "tick"
          IO.puts "number of clients: #{num_of_clients}"

          if num_of_clients > 0 do
            client = Enum.at(clients, current)
            send client, { :tick }
            current =
              if current >= num_of_clients - 1,
              do: 0,
            else: current + 1

            generator(clients, current)
          end

          generator(clients, current)
    end
  end
end


defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts "tock in cilent"
        receiver()
    end
  end
end
