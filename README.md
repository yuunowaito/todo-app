# Todo App

自分用のシンプルな Todo アプリ。機能はタスクの **一覧 / 追加 / 完了・未完了の切り替え / 削除** の4つのみ。ログイン機能はなし。

- Ruby 3.3
- Rails 7.2
- PostgreSQL

## ローカル開発（Docker）

```bash
docker compose up --build
```

- 初回起動時に `db:migrate` が自動実行される
- http://localhost:3000 で開く

テストの実行:

```bash
docker compose run --rm \
  -e RAILS_ENV=test \
  -e DATABASE_URL=postgresql://postgres:password@db/todo_test \
  web bash -c "bundle exec rails db:prepare && bundle exec rails test"
```

## Render へのデプロイ

`render.yaml`（Blueprint）で Web サービスと PostgreSQL を定義済み。

1. このリポジトリを GitHub に push する
2. Render のダッシュボードで **New → Blueprint** を選び、リポジトリを指定する
3. `RAILS_MASTER_KEY` を Render の環境変数に設定する（値は `config/master.key` の中身）
   - `config/master.key` は Git 管理外なのでローカルの値をコピーする
4. デプロイ後、`https://<service>.onrender.com` で開く

ビルドは `bin/render-build.sh`（gem インストール → アセットプリコンパイル → `db:migrate`）で実行される。

> 注: `render.yaml` の `plan: free` は Render の無料枠。無料の PostgreSQL には有効期限があるため、
> 継続利用する場合は有料プランへの変更を検討すること。
