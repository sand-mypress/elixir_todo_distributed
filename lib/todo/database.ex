# Todo.System supervisor
#   |- Todo.Database supervisor
#       |- Todo.DatabaseWorker1 worker
#       |- Todo.DatabaseWorker2 worker
#       |- Todo.DatabaseWorker3 worker

defmodule Todo.Database do
  # @pool_size 3
  @db_folder "./persist"

  # def start_link do
  #   IO.puts("Starting to-do Database")
  #   File.mkdir_p!(@db_folder)
  #   children = Enum.map(1..@pool_size, &worker_spec/1)
  #   Supervisor.start_link(children, strategy: :one_for_one,  name: __MODULE__)
  # end

  # defp worker_spec(worker_id) do
  #   # {module-name, start_link-argument}
  #   default_worker_spec = {Todo.DatabaseWorker, {@db_folder, worker_id}}
  #   # child_spec(module_or_map, overrides)
  #   Supervisor.child_spec(default_worker_spec, id: worker_id)
  # end

  # def child_spec(_arg) do
  #   %{
  #     id: __MODULE__,
  #     start: {__MODULE__, :start_link, []},
  #     type: :supervisor
  #   }
  # end

  def child_spec(_) do
    # File.mkdir_p!(@db_folder)
    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DatabaseWorker,
        size: 3
      ],
      [@db_folder]
    )
  end


  # def store(worker_id, data) do
  #   worker_id
  #   |> choose_worker()
  #   |> Todo.DatabaseWorker.store(worker_id, data)
  # end

  # def get(worker_id) do
  #   IO.puts("get for #{worker_id}")
  #   worker_id
  #   |> choose_worker()
  #   |> Todo.DatabaseWorker.get(worker_id)
  # end

  # defp choose_worker(worker_id) do
  #   :erlang.phash2(worker_id, @pool_size) + 1
  # end

  def store(key, data) do
    {_results, bad_nodes} =
      :rpc.multicall(
        __MODULE__,
        :store_local,
        [key, data],
        :timer.seconds(5)
      )
    Enum.each(bad_nodes, &IO.puts("Store failed on node #{&1}"))
    :ok
  end

  def store_local(key, data) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.store(worker_pid, key, data)
        end
    )
  end

  def get(key) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.get(worker_pid, key)
      end
    )
  end

end
