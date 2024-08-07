npm install

npm run dev
で起動。hotreloadです。


参照ページ
Google Map Platform
https://developers.google.com/maps/documentation/javascript/dds-boundaries/style-polygon?hl=ja&authuser=2

Google Map PlatformのMapstyleより区単為に変更しています

### Directions APIについて
Directions APIを実験的にブラウザのurlで利用する際は API keyのIPアドレスの制限に自身のIPアドレスを設定することでAPI keyを利用できるようにする必要があります。
# 手順
1,google cloud platformで"mori@ai-ot.com"のアカウントにログイン。(パスワードがわからない場合は森さんに聞いてください)
2,左上のナビゲーションメニューからAPIとサービスにアクセス。
3,左の認証情報をクリック。
4,"Directions API"という名前のAPIキーをクリック。
5,IPアドレスの制限に自身のIPアドレスを追加。RE
6,下の保存ボタンをクリック。