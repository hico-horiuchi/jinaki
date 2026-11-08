# CLAUDE.md

## 概要

jinaki (地鳴) は esa の日報の更新を Webhook で受け取り、記事を公開共有して Slack に通知する Sinatra アプリケーションである。

## コマンド

```shell
bundle install                            # 依存パッケージのインストール
bundle exec rspec                         # テストの全件実行
bundle exec rspec spec/model/post_spec.rb # 単一ファイルのテスト実行
bundle exec rubocop                       # Lint
bundle exec puma -C config/puma.rb        # Web サーバー起動
bundle exec rake jinaki:gc                # 公開期間を過ぎた日報の共有解除
bundle exec rake jinaki:wakatime          # 前日の日報に WakaTime の集計をコメント
```

Rake タスクは `.env` の認証情報で実際の esa と WakaTime の API を呼び出す。

## アーキテクチャ

- 処理は `App` → `Route` → `Controller` → `Model` → `Helper` の順に委譲し、`lib/jinaki.rb` はその逆順に読み込む
- マウントの定義は `config.ru` と `spec/spec_helper.rb` の `app` の両方にあるため、変更するときは両方を更新する
- Rake タスクの処理は `Rakefile` に直接書かれており、テストがない
- `PUBLICATION_PERIOD_DAYS` (既定 7) の計算は `Rakefile` と `Model::Post#period_exceeded?` の両方にあるため、変更するときは両方を更新する

### Webhook の設計上の要点

- `Rack::EsaWebhooks` による署名検証は production でのみ有効である
- 日報への絞り込みは esa の Webhook 設定の Filter (`^/日報/`) に依存し、コードではカテゴリを判定しない
- esa の Webhook 設定では on post create も有効だが、`Controller::Esa` は `post_update` のみを処理する

## 環境変数

- 本番では CD が `.env.enc` を復号した `.env` を一緒にデプロイし、`DOKKU_APP_TYPE` がある場合に `Dotenv.load` で読み込む
- 環境変数を追加するときは `.env.sample` / `app.json` / `.env.enc` を更新する
- `.env.enc` の更新はユーザーに依頼する

## コーディング規約

- 1 行のブロックの引数には `it` を使い、複数行のブロックには名前付きの引数を使う
- コミットメッセージは `:gitmoji: 英語の件名` の形式で書く (例: `:arrow_up: Update ruby to 4.0.9`)
