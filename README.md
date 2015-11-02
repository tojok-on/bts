こまどりおねえちゃんしすてむ（鉄）
----

「こまどりおねえちゃんしすてむ（鉄）」はTOJO K-ONのセッティング表を作るシステムだよっ☆

# ローカルでの動かし方 

```bash
$ git clone https://github.com/tojok-on/bts.git
$ cd bts
$ bundle install --path vendor/bundle
$ bundle exec ruby bts.rb
```

Open `http://localhost:4567/`.
もし上記アドレスで開けない場合はbundle exec のメッセージを見て別のポートで開いていないか確認してください．

```bash
$ bundle exec ruby bts.rb                                                                                                                                      [23:14:21]
== Sinatra/1.4.5 has taken the stage on 4567 for development with backup from Thin
Thin web server (v1.6.3 codename Protein Powder)
Maximum connections set to 1024
Listening on 0.0.0.0:4567, CTRL+C to stop  ← このアドレス
```

# Docker usage

```bash
docker pull nownabe/bts:latest
docker run --name="bts" -d -p 80:80 -v /var/pdf:/usr/src/app/public/pdf nownabe/bts
```

# heroku へのデプロイの仕方 (簡易)

1. heroku のアカウントを 作ります (https://www.heroku.com)
2. heroku toolbelt をインストールします (https://toolbelt.heroku.com/)
3. 端末で`heroku login`を実行
4. `cd bts` でディレクトリに移動して `heroku create`を実行
6. `git push heroku master`を実行
7. `bundle exec heroku open`を実行

アドレスを変更したい場合

1. `heroku rename 新しい名前` を実行
2. `bundle exec heroku open`
