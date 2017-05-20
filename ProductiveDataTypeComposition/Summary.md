Summary
====

# Introduction

今まで同じことをなすために色んな方法を試してきた。
確かに、別の方法でも似たようなことはできなくはなかった。

けれど、計算コストや実装の煩雑さなどから、やはりこれは新しい機能が必要ではないかと結論付けるに至った。
これはOOP, 例えばJavaの`extend`のように見えるかもしれない。
しかし、これが提案するのはそうではない。
PolymorphismとStrict data typeを活用すべく、また維持補修のし易くするために、data typeの定義方法に新しいものを一つ付け加えたいということである。

Strict type systemを壊すことなく、維持補修しやすいpolymorphicな関数を作るためのdatatypeの拡張。

それなりに長い時間Haskellを使ってきたけど、実はそこまでHaskellに詳しいわけでもない。
もしかすると、より良い方法や同等の機能を提供する何かがすでにあるのかもしれない。
結構探してきたつもりだけど、目の前にしてなお理解できなかったかもしれない。

# 提案内容

## 機能一覧

* レコードフィルドの組み合わせ
* それに対するレコード更新インタフェースの統一（直接実装しなくて済むように）

## 求めるもの

* 維持補修のしやすさ
* 重くない実装

## 例えば

```
data Core = Core
  { a :: Int
  , b :: String
  } -- derivingが使えるのか、どう使われるべきかは不明。多分結合した方で考えるべきじゃないかな？

data ExtendCore01 = EC01
  { Core
  , c :: Int
  , d :: String
  }

data ExtendCore02 = EC02
  { Core
  , e :: Int
  , f :: String
  }
```

文法的に格好悪いので何か別の定義の方法を考えるべきだと思うけど、要はこういうものである。
これをコンパイラーが読み込んだときには次のように解釈すべきである。

```
data Core = Core
  { a :: Int
  , b :: String
  }

data ExtendCore01 = EC01
  { a :: Int
  , b :: String
  , c :: Int
  , d :: String
  }

data ExtendCore02 = EC02
  { a :: Int
  , b :: String
  , e :: Int
  , f :: String
  }
```

# 何が嬉しい？

## record field functionがPolymorphicに使える。

```
v1 = Core 1 "s"
v2 = EC01 2 "o" 4 "e"
v3 = EC02 3 "m" 5 "t"
```
のように定義されている場合、

```
> a v1
1
> a v2
2
> a v3
3
```
のように振る舞えるレコードフィルドアクセス関数`a`,`b`が得られる。

もちろん、これを組み合わせ`Core`,`EC01`,`EC02`が含まれるあるクラスに対するpolymorphicな関数も作れる。

さらに
```
> v1 {a=4}
Core 4 "s"
> v2 {a=5}
EC01 5 "o"
> v3 {a=6}
EC02 6 "m"
```
のようにも働くだろう。

普通に `EC01`と`EC02`を実装すればいいじゃないかと思うかもしれない。

問題は、`Core`に属するデータ構造を変更したいときである。

もし、新しく`EC01`,`EC02`にレコード`z :: Double`を追加したくなったとする。
上記の提案通りなら
```
data Core = Core
  { a :: Int
  , b :: String
  , z :: Double
  }
```
にして、それを活用する関数を作ればよい。

# どうしてSum dataにしないのか?

```
data EC
  = EC01
  { a :: Int
  ...
  , d :: String
  }
  | EC02
  { a :: Int
  ...
  , f :: String
  }
```
のようにすれば良いと考えるかもしれない。
確かに、滅多のことがない限り、同じく機能するだろう。
Compositabilityは損なわれるが、一つのdata definitionに並んでいるので、
**気をつければ** 十分にエラーを回避可能である。
ただ、私からすればそれはType systemの良さを否定するような言い方のように聞こえる。

もちろん既存に提供されるHaskellのtype systemは十分に強力でこれくらいはプログラマーのやるべき仕事と言いたくなるのもわかる。
newtypeやPhantom typeのような煩雑なやり方も好かない人もいるだろう。
もちろんPhantom typeやnewtypeも正義じゃない。
が、それが活かされる場面というのは確かにあるし、便利である。

この提案もそのようなものの一つになれないかなという思いによるものだ。
活用される場面がどれくらいあるのかは不明ではある。
ただ、私個人としては使える場面は多く、これによって表現力は広がるかは分からないが、ぜひ導入されればと思う。

## Caveat

### Strict data systemを犯すものではないのか？

違う。必要があれば（そして必要だろうけれど）`Core`を利用した（組み込まれた）data typeはすべて同じclassに属する必要があるだろう。でないと`a`のtypeはどうなのか難しくなる。
暗黙的に次のようなメソッドが定義されるイメージだ。（多分レコードはこういうふうに提起しないんだと思うけどよくわからない）

```
instance Core ES01 where
  a (ES01 w _ _ _) = w
  b (ES01 _ x _ _) = x
instance Core ES02 where
  a (ES02 w _ _ _) = w
  b (ES02 _ x _ _) = x
```

一応`deriving Core`をつけても良いが、暗黙的でもかまわないと思う。
もしくは、`deriving`をつけるだけで自動的にproductされても良いんだけど、レコードの順序が明示的でないなどの問題があるので難しいというか良くない。
GADTsは順序とか気にしたっけ？

# 問題点

## `Core`の`instance`, `deriving`は継承できない。

自明ではないために継承できない。
考えてみると当たり前だけど、ちょっと惜しい。
ただ、`Core`の`instance`ではなくとも、別の`class`メソッドとしては共通したfunctionが作れるべきである。

## 関数型言語っぽくない/Haskellらしくない

私もそこまで言語パラダイムなどに詳しくはない。
けれど、これは別にJavaのExtendedを真似たりOOPを真似たりするためのものではない。
むしろpolymorphismをより簡単に広く使うためだけの提案である。

## Sum-typeとの折り合いは？

例えば、Sum-typeの一つの中に`Core`のようなデータ型を組み込むことは可能だろうか？
厳密に言えば、選択的に適用することが可能だろうか？
classとして考えるならば、そう簡単にはできないだろう。
````
data ExtendCore03
  = EC03A
  { Core
  , i :: Int
  , j :: String
  }
  | EC03B
  { k :: Int
  , l :: String
  }
````
のようになる場合、`a`や`b`に当たるものが`EC03B`に存在しない。
classの実装としては問題なのだが、sum-typeとしてはいつものことなので問題じゃないかもしれない。
まあ、実際にそれによるバグもあり得るんだけど。

これによるバグを許容するか？
それともclassだから、適切に実装することを強制するか？
別のclassでも一応具体的な動作は違ってもちゃんと実装するようになっているから問題ではないかもしれない。

# 他のアプローチ

* Polymorphicな関数が作れない
* (Polymorphicな?) Record updateが出来ない
* 維持補修しやすい

以下のアプローチからこの2つを満たす方法が存在しない。(全然関係ない・使えないアプローチも挙げているけど、検討した対象はすべて挙げた)
複雑な実装をすればできるけど、それらの全ては維持補修しにくいか、求められる条件を満たせない。

* Generics
* TemplateHaskell
* SYB
* Lens
* GADTs
* DuplicatedRecordFields
* BackPack

# 難易度

難易度に関しては私はよく知らない。
多分文法解析的にややこしくなるのはあるが、適宜変換しつつ暗黙のうちにクラスを導入・メソッドを導出するような手間がかかるのではないかと思う。Type systemに関しては影響しないと思うけど、record field更新関数に関しては難しいのかもしれない。
また、メソッドの名前は自動導出しても構わないが、クラスの名前の自動導出は同じ名前を持つデータ型名前とクラス名前をするには何かが必要だらう。