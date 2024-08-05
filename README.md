npm install

npm run dev
で起動。hotreloadです。


参照ページ
Google Map Platform
https://developers.google.com/maps/documentation/javascript/dds-boundaries/style-polygon?hl=ja&authuser=2

Google Map PlatformのMapstyleより区単為に変更しています

### src/Map.svelte　107行目以降のコードについて
・このコードは地図上に点を設置し三角形を作成するコードです。
・点は三つまでしか設置できません。
・左下のリセットボタンを押すことで設置した点をリセットできます。
・作成した三角形の範囲内にあるポリゴンを表示する機能の実装を目指していますが、現時点では三角形を作成することしかできません。