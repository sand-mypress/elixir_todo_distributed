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