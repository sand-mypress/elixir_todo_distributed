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
# gitのremote urlを変更する(レポジトリ移行時)
# todoはchap10までをkeep。chap11(poolboy)を別プロジェクトに移す。
git remote -v
git remote set-url origin git@github.com:sand-mypress/elixir_todo_poolboy.git
git push