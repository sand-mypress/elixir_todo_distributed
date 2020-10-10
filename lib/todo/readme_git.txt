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
