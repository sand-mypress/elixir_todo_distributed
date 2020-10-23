# Todo.System supervisor
#   |- Todo.Cache supervisor(Dynamic)
#       |- Todo.Server name1 worker
#       |- Todo.Server name2 worker
#       |- Todo.Server name3 worker
#       |- Todo.Server name4 worker
#       |- Todo.Server name5 worker

defmodule Todo.Cache do
  def start_link() do
    IO.puts("Starting to-do cache")
    DynamicSupervisor.start_link(
        name: __MODULE__,
        strategy: :one_for_one
    )
  end


  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  # def server_process(todo_list_name) do
  #   case start_child(todo_list_name) do
  #     {:ok, pid} -> pid
  #     {:error, {:already_started, pid}} -> pid
  #   end
  # end

  def server_process(todo_list_name) do
    existing_process(todo_list_name) || new_process(todo_list_name)
  end

  defp existing_process(todo_list_name) do
    Todo.Server.whereis(todo_list_name)
  end

  defp new_process(todo_list_name) do
      case DynamicSupervisor.start_child(
        __MODULE__,
        {Todo.Server, todo_list_name}
      ) do
        {:ok, pid} -> pid
        {:error, {:already_started, pid}} -> pid
      end
  end

  # defp start_child(todo_list_name) do
  #   # start_child(supervisor, child_spec)
  #   # child_spec = {module(), term()}
  #   DynamicSupervisor.start_child(
  #       __MODULE__,
  #       {Todo.Server, todo_list_name}
  #   )
  # end
end
