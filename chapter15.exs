defmodule MP do
  def start do
    receive do
      msg ->
        IO.puts msg
        start()
    end
  end
end

fred = spawn(MP, :start, [])
betty = spawn(MP, :start, [])

send(fred, "fred")
send(betty, "betty")


# wmp345
defmodule Parent do
  def run do
    IO.puts "STARTED PARENT"
    Process.flag(:trap_exit, true) # =
    spawn_monitor(Child, :run, [self()])
    :timer.sleep(1000)
    receive_msgs()
    IO.puts "PARENT EXITED"
  end

  def receive_msgs() do
    receive do
      {:DOWN, ref, :process, object, reason} ->
        IO.puts "children is down #{reason}"
        receive_msgs
      msg ->
        IO.puts "#{inspect msg}"
        receive_msgs
    end
  end
end

defmodule Child do
  def run(sender) do
    IO.puts "STARTED CHILD"
    send(sender, "sending message from child")
    send(sender, "sending message from child")
    send(sender, "sending message from child")
    exit(:some_reason)
    send(sender, "sending message from child")
    raise RuntimeError # =
    IO.puts "CHILD EXITED"
  end
end

Parent.run

# wmp4
