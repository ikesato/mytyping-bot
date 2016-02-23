概要
====

myTyping をスクレイプして、ランキングが更新されたかを監視します。
あと、以下のチァットコマンドを解釈する bot を作ります。


### commands

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
|settings           |全設定表示              |
|set <name>=<value> |設定変更                |

#### list

> list
1  1234560  親指シフト練習１
2  1234561  abcdefghiljklm２


#### del <typing_id>

> del 1
deleted {id:1, mytyping_id:1234560, name:親指シフト練習１}
OK

#### add <myTyping ID>

> add 1234562
added {id:3, mytyping_id:1234562, name:親指シフト練習２}
OK

#### ranking [typing_id]

> ranking 1
rank  name  score
