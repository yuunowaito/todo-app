# CLAUDE.md

このファイルは Claude Code がこのリポジトリで作業するときのガイドです。

## プロジェクト概要

自分用のシンプルな Todo アプリ。機能は **タスクの一覧 / 追加 / 完了・未完了の切り替え / 削除** の4つのみ。
ログイン機能は持たせない。スコープを広げる変更は事前に確認すること。

- Ruby 3.3 / Rails 7.2 / PostgreSQL 16
- Hotwire + importmap + Sprockets、Puma
- ローカルは Docker Compose、本番は Render

## ワークフロー上のルール

- **機能が完成したら、コミットする前に「ここまでを保存しますか？」と確認する。** 承認を得てからコミットする。
- コミットは日本語メッセージで簡潔に。
- 変更後は必ずテストを実行して結果を報告する。

## コマンド

ローカルの Ruby は 3.0 / Rails 6.1 と古いため、rails・bundle 系のコマンドは必ず Docker 経由で実行する。

```bash
# 起動 / 停止
docker compose up --build
docker compose down

# テスト
docker compose run --rm \
  -e RAILS_ENV=test \
  -e DATABASE_URL=postgresql://postgres:password@db/todo_test \
  web bash -c "bundle exec rails db:prepare && bundle exec rails test"

# RuboCop / Brakeman
docker compose run --rm web bin/rubocop
docker compose run --rm web bin/brakeman -q --no-pager

# マイグレーション生成など任意の rails コマンド
docker compose run --rm web bin/rails <command>
```

## 実装状況

4機能すべて実装・テスト済み（`main` に push 済み）。単一画面（`tasks#index`）で完結。

| 機能 | 実装 |
| --- | --- |
| 一覧 | `TasksController#index` が `Task.ordered`。0件時はビューで「タスクはありません」 |
| 追加 | `#create`。`form_with model: @task`。空タイトルは `render :index, status: :unprocessable_entity` |
| 完了トグル | `#toggle`（`PATCH /tasks/:id/toggle`）。ビューは `button_to`。完了は `.is-completed` で取り消し線 |
| 削除 | `#destroy`。`button_to` に `data: { turbo_confirm: "削除しますか？" }` |

## 構成メモ

- `Task` モデル: `title`（必須）, `completed`（boolean, デフォルト false）。`scope :ordered` は `order(:completed, created_at: :desc)`（未完了が上、各グループ内は新しい順）
- ルート: `root "tasks#index"` + `resources :tasks, only: [:index, :create, :destroy]` に `patch :toggle`（member）
- スタイルは `app/assets/stylesheets/application.css` に直書き（`.task.is-completed .title { text-decoration: line-through }` など）
- テスト: `test/models/task_test.rb`、`test/controllers/tasks_controller_test.rb`
- `config/database.yml` の production は `DATABASE_URL` を参照
- 本番の SSL リダイレクトから `/up`（ヘルスチェック）を除外済み

## Git

- このディレクトリが独立した git リポジトリ（`main` ブランチ）。ホームディレクトリ `~` も
  コミットゼロの git リポジトリになっているため、git コマンドは必ずこのディレクトリ内で実行する。
- author: `yuunowaito <nowaito45@gmail.com>`
- リモート: `origin` = https://github.com/yuunowaito/todo-app.git

## デプロイ（Render）

- `render.yaml`（Blueprint）で Web + PostgreSQL を定義
- ビルドは `bin/render-build.sh`
- `RAILS_MASTER_KEY` は Render の環境変数に手動設定が必要（`config/master.key` の中身）
- 詳細は `README.md` を参照
