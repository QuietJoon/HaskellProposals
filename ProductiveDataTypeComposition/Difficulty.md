難易度
====

実装に至るまでの難易度に関しては、私はHaskellに詳しくなくてよく知らない。
多分文法解析的にややこしくなるのはあるが、適宜変換しつつ暗黙のうちにクラスを導入・メソッドを導出するような手間がかかるのではないかと思う。
Type systemに関しては影響しないと思うけど、record field更新関数に関しては難しいのかもしれない。
また、メソッドの名前は自動導出しても構わないが、クラスの名前の自動導出は同じ名前を持つデータ型名前とクラス名前をするには何かが必要だらう。


# クラスの自動導出

基本的にメソッドは自動導出しても良い。
しかし、クラスは自動導出するのはややこしい。

