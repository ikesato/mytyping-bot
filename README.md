概要
====

myTyping と言うタイピングサイトの監視ボットです。
Slack にランキング更新結果を出力します。



### commands

Slack チャットで以下 command を受け付けます。

|command            |description             |
|-------------------|------------------------|
|help               |ヘルプ表示              |
|list               |登録タイピング一覧      |
|del <typing_id>    |タイピング削除          |
|add <myTyping ID>  |タイピング追加          |
|ranking [typing_id]|ランキング表示          |
|updates            |間近３日間の更新表示    |
|roukies            |間近３日間の新規ユーザー|
|sync               |ランキング更新          |
|sync-updates       |ランキング更新と表示    |
|settings           |全設定表示              |
|set <name>=<value> |設定変更                |

updates と rouikes と sync-updates でチェックする３日間の間隔は
set watching_days=N で変更可能です。

