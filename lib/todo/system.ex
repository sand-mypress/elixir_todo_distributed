# Top-level supervisor
# [{pid,_value}]=Registry.lookup(Todo.ProcessRegistry, {Todo.Server, 'tanaka'})
#
# iex -S mix
#
# --- defmodule Todo.Server do
# ---   use GenServer, restart: :temporary
# Todo.System.start_link()
# tanaka_pid=Todo.Cache.server_process('tanaka') -- pidでTodo.Serverにアクセス
# Todo.Server.add_entry(tanaka_pid, %{date: ~D[2018-12-19], title: "Dentist"})
# Todo.Server.add_entry(tanaka_pid, %{date: ~D[2018-12-19], title: "kooking"})
# Todo.Server.entries(tanaka_pid, ~D[2018-12-19])
# Process.exit(tanaka_pid, :kill)
# tanaka_pid=Todo.Cache.server_process('tanaka') -- 手動で再起動
# Todo.Server.entries(tanaka_pid, ~D[2018-12-19])
# Todo.DatabaseWorker.stop(1)　-- Database.Workerが自動的に再起動
# pid = Process.whereis(Todo.Cache)
# Process.exit(pid, :kill) -- Todo.Cacheが自動的に再起動
# pid = Process.whereis(Todo.Database)
# Process.exit(pid, :kill) -- Todo.DatabaseとDatabase.Workerが自動的に再起動
#
#
# --- defmodule Todo.Server do
# ---   use GenServer
# Todo.System.start_link()
# tanaka_pid=Todo.Cache.server_process('tanaka')
# Todo.Server.entries_name('tanaka', ~D[2018-12-19])
# Process.exit(tanaka_pid, :kill) -- 自動的に再起動
# Todo.Server.entries_name('tanaka', ~D[2018-12-19])
#

defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        Todo.Metrics,
        Todo.ProcessRegistry,
        Todo.Database,
        Todo.Cache,
        Todo.Web
      ],
      strategy: :one_for_one
    )
  end
end
