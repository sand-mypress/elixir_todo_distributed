defmodule Todo.Server do
  use GenServer, restart: :temporary
  # use GenServer

  def start_link(name) do
    IO.puts("Starting to-do server for #{name}")
    GenServer.start_link(__MODULE__, name, name: global_name(name))
  end

  defp global_name(name) do
    {:global, {__MODULE__, name}}
  end

  def whereis(name) do
    case :global.whereis_name({__MODULE__, name}) do
      :undefined -> nil
      pid -> pid
    end
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  def add_entry_name(name, new_entry) do
    GenServer.cast(via_tuple(name), {:add_entry, new_entry})
  end

  def entries_name(name, date) do
    GenServer.call(via_tuple(name), {:entries, date})
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  # def whereis(name) do
  #   Todo.ProcessRegistry.whereis_name({:todo_server, name})
  # end


  def init(name) do
    IO.puts("init for #{name}")
    {:ok, {name, Todo.Database.get(name) || Todo.List.new}}
  end


  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end


  def handle_call({:entries, date}, _, {name, todo_list}) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      {name, todo_list}
    }
  end

  # Needed for testing purposes
  def handle_info(:stop, state), do: {:stop, :normal, state}
  def handle_info(_, state), do: {:noreply, state}
end
