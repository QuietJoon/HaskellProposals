他のアプローチ
====

どうして新しい機能を導入しないといけないのか？
既存の方法による実装方法ではだめなのか？

主な理由は2つ

* Polymorphicな関数が作れない
* Record updateが出来ない

二つ目のrecord updateもpolymorphicと似たようなものだが、一応違うはずなので別にしてある。実際動きも違うだろうし。

## 他の何もいらない（もう何も要らない）

普通にclassとそのインスタンスを定義すれば作れる。
ただ、非常に堪える、またミスしやすいし、維持補修し続けるには難がある作業になる。
実際にやってみたが、決して良くない。

入れ子構造にする場合、一つのデータあたり100行以上必要なものが今回提案する機能が実装されれば数行で終わる。
その上、入れ子にするならばアクセスへのオーバーヘッドもある。無視できる程度かもしれないし、最適化すればなくなるのかもしれない。

## Genericは？

試そうとした。
けれど、何層も重ねる、いやたった二層構造と一層構造が2つあるだけでもどうやってGenericを作れば良いのかわからなかった。
Genericは勉強すべきだが、今回の課題を解決するにはあまりにも難しい。
少なくとも、私は似たコンセプトを実現するための実装を見つけられていない。

## THはどうだろう？

一番近い方法である。ただしすべての方法を満たすものではない。
何より作りにくい。決して維持補修しやすい方法ではない。
今回の提案のように未だないものを実装するためには使えるものではあるが、
私はこの提案はより広く、手頃に使われるべきものではないのかと考える。
Polymorphicの問題は解決できないかもしれない。


## SYBは？

使えるもののようだが、実は中身をよく知らない。

## Lensは？

LensはTHなどを用いた非常に強力なライブラリーである。
GetterやSetterを使えば多分できる。
が、Polymorphicなやり方はできないだろう。

## General Algebric Datatypesは？
使えるのか？

## DuplicatedRecordFieldsは

取り出すだけなら利用可能だ。
未だ(GHC 8.0.2)に付け加えるべきものが多く存在していて使いやすくはないんだけど。
その上polymorphicな使い方はできない。それくらいしてくれたら良かったんだが、難しいだろう。


## BackPack

最初は使えるとは思っていなかったけど、使えそうにも見える。
ただ、すべてを解決するものではない。
