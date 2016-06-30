# Clicker

ラバードーム式とかの静かなキーボードがカチカチ言うようにするプログラム
です。

## 要求

1. Linux で動きます。
2. evtest プログラム。Ubuntu のような DPKG ベースのディストリビューショ
   ンでは、`sudo apt install evtest` でインストールされると思います。
3. キーボードデバイスへのアクセス権限。すなわち、
   `/dev/input/by-path/platform-i8042-serio-0-event-kbd` が開ける必要
   があります。通常、開けないので、デバイスファイルのパーミッションを
   変更するか、ユーザーを input グループに追加してください。`sudo
   addgroup ユーザー名 input`[^1]
4. SDL_mixer ライブラリがインストールされ、rubysdl ジェムから利用でき
   る必要があります。`sudo apt install libsdl-mixer1.2-dev` 等とした後、
   rubysdl ジェムを(再)インストールしてください。

[^1]: 通常、任意のプログラムからキーボードを盗聴できるようにするのは、良い考えではありません。

## インストール

    $ sudo apt install evtest
    $ sudo addgroup ユーザー input
    $ sudo apt install libsdl-mixer1.2-dev
    $ sudo gem install clicker

## 使い方

以下のようにするとキーを押すたびに音がなるようになります。

    $ clicker

バックグラウンドで実行したい場合は、

    $ clicker --start

とします。

終了させたい場合は、`clicker --stop` としてください。

## 貢献する

https://github.com/plonk/clicker にリポジトリがあります。

