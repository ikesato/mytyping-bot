概要
====

myTyping と言うタイピングサイトの監視ボットです。
Slack にランキング更新結果を出力します。



### commands

Slack チャットで以下 command を受け付けます。

|command               |description             |
|----------------------|------------------------|
|help                  |ヘルプ表示              |
|list                  |登録タイピング一覧      |
|del _typing_id_       |タイピング削除          |
|add _myTyping ID_     |タイピング追加          |
|ranking _[typing_id]_ |ランキング表示          |
|updates               |間近３日間の更新表示    |
|roukies               |間近３日間の新規ユーザー|
|sync                  |ランキング更新          |
|sync-updates          |ランキング更新と表示    |
|settings              |全設定表示              |
|set _name_ = _value_  |設定変更                |

updates と rouikes と sync-updates でチェックする３日間の間隔は
set watching_days=N で変更可能です。

### Lisence

MIT: http://rem.mit-license.org