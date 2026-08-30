# Todo App

## 概要

自分用のシンプルな Todo アプリ。タスクを登録して、日々の「やること」を管理する。
ログイン機能はなく、単一の画面ですべての操作が完結する。

- リポジトリ: https://github.com/yuunowaito/todo-app

## 機能

4機能すべて実装済み。

- タスクの一覧表示（未完了を上、新しい順。タスクが無いときは「タスクはありません」と表示）
- タスクの追加（フォームにタスク名を入力して送信。空欄はバリデーションエラー）
- タスクの完了・未完了の切り替え（完了タスクは取り消し線＋グレー表示）
- タスクの削除（削除前に「削除しますか？」の確認ダイアログ）

## 使用技術

| 分類 | 技術 |
| --- | --- |
| 言語 | Ruby 3.3 |
| フレームワーク | Rails 7.2 |
| データベース | PostgreSQL 16 |
| フロントエンド | Hotwire (Turbo / Stimulus)、importmap、Sprockets |
| Web サーバー | Puma |
| ローカル環境 | Docker / Docker Compose |
| デプロイ | Render (Blueprint) |
| テスト | Minitest（モデル / 結合テスト） |
| 静的解析 | RuboCop (rails-omakase)、Brakeman |

## ローカル起動方法

Docker と Docker Compose があれば OK。

```bash
docker compose up --build
```

- 初回起動時に `rails db:migrate` が自動実行される
- ブラウザで http://localhost:3000 を開く

停止:

```bash
docker compose down
```

### テストの実行

Minitest でモデル・結合テストを用意している（`test/models/task_test.rb`、`test/controllers/tasks_controller_test.rb`）。

```bash
docker compose run --rm \
  -e RAILS_ENV=test \
  -e DATABASE_URL=postgresql://postgres:password@db/todo_test \
  web bash -c "bundle exec rails db:prepare && bundle exec rails test"
```

## デプロイ先

**Render**（[https://render.com](https://render.com)）にデプロイする。
`render.yaml`（Blueprint）で Web サービスと PostgreSQL を定義済み。
コードは GitHub（https://github.com/yuunowaito/todo-app）に push 済み。

1. Render のダッシュボードで **New → Blueprint** を選び、`yuunowaito/todo-app` を指定する
2. `RAILS_MASTER_KEY` を Render の環境変数に設定する
   - 値は `config/master.key` の中身（このファイルは Git 管理外）
3. デプロイ後、`https://<service-name>.onrender.com` で公開される
4. 以降は `main` ブランチへの push で自動デプロイされる

ビルドは `bin/render-build.sh`（`bundle install` → アセットプリコンパイル → `rails db:migrate`）で実行される。

> 注: `render.yaml` の `plan: free` は Render の無料枠。無料の PostgreSQL には有効期限があるため、
> 継続利用する場合は有料プランへの変更を検討すること。
