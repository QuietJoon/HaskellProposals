Sum-Product Composition
====

私のやりたいことのうちに次のようなものがある。
```
data Animal = Animal
  { health :: Int
  , age    :: Int
  }

data Human
  = MaleHuman
  { Animal
  , mParam :: Int
  }
  | FemaleHuman
  { Animal
  , fParam :: Double
  }
```

まず、ここまでは問題ない。

しかし、次のような拡張がしたいんだけど、

```
data Animal = Animal
  { health :: Int
  , age    :: Int
  }

data Human
  = MaleHuman
  { Animal
  , mParam :: Int
  }
  | FemaleHuman
  { Animal
  , fParam :: Double
  }

data Staff
  = Staff
  { Human
  , sParam :: String
  }

```

このような拡張は自然だけど、`Staff`は一体どのように解かれるべきかわからない。

もちろん、FemaleHumanに関してもMaleHumanに関してもStaffが得られるべきだ。
それも同じdatatypeである必要がある。
だから、多分次のように展開するべきだろう。
面倒くさいので`MaleHuman`と`FemaleHuman`の中身は全部は展開しない。

```
data Animal = Animal
  { health :: Int
  , age    :: Int
  }

data Human
  = MaleHuman
  { Animal
  , mParam :: Int
  }
  | FemaleHuman
  { Animal
  , fParam :: Double
  }

data Staff
  = MaleStaff
  { MaleHuman
  , sParam :: String
  }
  | FemaleStaff
  { FemaleHuman
  , sParam :: String
  }
```

自動導出されるdata constructorの名前を考えれば、`MaleStaff`ではなく、`MaleHumanStaff`だろう。

ならば、`Human`のdata constructorで`Male`と`Female`だけを使い、`MaleHuman`と`FemaleHuman`にして、自動導出・追加されたものは無視してStaffのところでは`MaleStaff`と`FemaleStaff`にすれば良いのではないかとも思うだろう。

しかし、次の例を考えればそう簡単に行かない。


```
data Animal = Animal
  { health :: Int
  , age    :: Int
  }

data Human
  = MaleHuman
  { Animal
  , mHumanParam :: Int
  }
  | FemaleHuman
  { Animal
  , fHumanParam :: Double
  }

data Elf
  = MaleElf
  { Animal
  , mElfParam :: Int
  }
  | FemaleElf
  { Animal
  , fElfParam :: Double
  }

data Staff
  = Staff
  { [Human,Elf]
  , sParam :: String
  }
```

書き方は貧しいが、とりあえず、Staffに関して`Elf`も`Human`をそれぞれ組み込んだものを生成したいという気持ちだけ理解してほしい。
ならば、結果として`Staff`は次のように展開されるべきである。

```
data Staff
  = MaleHumanStaff
  { MaleHuman
  , sParam :: String
  }
  | FemaleHumanStaff
  { FemaleHuman
  , sParam :: String
  }
  | MaleElfStaff
  { MaleElf
  , sParam :: String
  }
  | FemaleElfStaff
  { FemaleElf
  , sParam :: String
  }
```
この例を考えれば、自動的に何かを省略してくれるのはまずいことがわかる。

言及してないが、ここまでで暗黙的にclassが３つ導出されている。
まず、全体に適用される`AAnimal`class。`Human`と`Staff`に適用される`AHuman`class。そして`Elf`と`Staff`に適用される`AElf`class。

何かOOPの死のダイアモンドの再来のような感覚を覚えるかもしれないが、違うことはわかるだろう。

簡単に言えば、`Staff` typeに関して`Human`と`Elf`が両方適用されていることが問題だ。

ただ、OOPのダイアモンドモンとは違い、`Staff`はちゃんとdata constructorで場合分けはされている。
少なくとも`MaleHumanStaff`と`FemaleHumanStaff`に`AElf`のメソッドを適用出来ないことはわかるから、とりあえず適当に`error`を入れておけば良い。
そうでなくてもSum-typeに関しては無いメソッドに関して警告は出さないわけだし、既存のスペック上問題にされないかもしれない。

名前がかぶった場合は問題だろうが、それは既存でも`DuplicatedRecordField`を使わない限り許されていないから考える必要は無いだろう。


言及してこなかったが、この提案の重要なところが一つはっきりしている。
入れ子構造ではかなり実装しにくいrecord取り出しと更新が一つのrecord fieldで処理可能であることがわかる。
これは非常にありがたい。
実際何度も作ってみたけど、すごく面倒くさい。

解決策として、Animalのデータだけを保持するデータ構造、Humanのデータだけを保持するデータ構造をそれぞれ別々に用意すれば良い。
ただ、それではプログラマーのやるべき仕事が非常に増える。
その上、データ構造によっては計算量は定数倍に増えていく。一回の処理が重くなければ我慢できるが、一度取り出すときに１秒かかる処理はこの例では３秒かかる。
プログラムと問題によるが、これは見過ごせる問題じゃない。



