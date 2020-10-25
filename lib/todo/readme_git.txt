==============
2020/10/11
C:\Users\User\git\Phoenix\todo>

git init
git add lib


C:\Users\User\git\Phoenix\todo>git status
On branch master


git commit -m "elixir in action chapter9"
echo "# elixir_todo" >> README.md

# ブランチ名変更？: master -> main
git branch -M main
# リモートの追加: git remote add リモート名 リモートURL
git remote add origin git@github.com:sand-mypress/elixir_todo.git
# リモート(origin)にブランチ(main)を登録
push -u origin main  -- ブランチ(main)をリモートに登録



==============
2020/10/17
# gitのremote urlを変更する(レポジトリ移行時)
# todoはchap10までをkeep。chap11(poolboy)を別プロジェクトに移す。
git remote -v
git remote set-url origin git@github.com:sand-mypress/elixir_todo_poolboy.git
git push

==============
2020/10/18
git remote -v
git remote set-url origin git@github.com:sand-mypress/elixir_todo_distributed.git
git push

$ iex --sname node1@localhost -S mix
$ iex --erl "-todo port 5555" --sname node2@localhost -S mix
iex(node1@localhost)1> Node.connect(:node2@localhost)

$ curl -d "" "http://localhost:5454/add_entry?list=bob&date=2018-12-19&title=Dentist"
$ curl "http://localhost:5453/entries?list=bob&date=2018-12-19"
$ curl -d "" "http://localhost:5453/add_entry?list=bob&date=2018-12-19&title=Movies"
$ curl "http://localhost:5454/entries?list=bob&date=2018-12-19"

===============
2020/10/24
PIDにはルールがあって、以下のようになっています。
1.2.3

1 どのnode上にあるprocessか(localなら、ゼロ)
2 local内でユニークなnodeの番号
3 ↑のnodeの番号が表現可能な範囲を超えると増加する

===============
2020/10/24
12.1.3 Process discovery - Global

* Globalだけで充分だろ。ローカルだけで通用するものは不要じゃね！
* とりあえず、以下の４つ
1 :global.register_name({:todo_list, "bob"}, self())
2 :global.whereis_name({:todo_list, "bob"})
*** Global registration can also be used with GenServer
3 GenServer.start_link(__MODULE__,arg,name: {:global, some_global_alias})
4 GenServer.call({:global, some_global_alias}, ...)


(*) Todo.Server implement
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

(*)補足 distributeの処理に :rpc を使う
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

===============
2020/10/24

11.2.1 Adding a dependency - poolboy

  defp deps do
    [
      {:poolboy, "~> 1.5"},


defmodule Todo.Database do
  # @pool_size 3
  @db_folder "./persist"

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
