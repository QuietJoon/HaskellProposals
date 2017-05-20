data CoreA = CoreA
  { a :: Int
  , b :: String
  } -- derivingが使えるのか、どう使われるべきかは不明。多分結合した方で考えるべきじゃないかな？

data ExtendCoreB = ECB
  { CoreA
  , c :: Int
  , d :: String
  } deriving Productive(Core)

data ExtendCoreC = ECC
  { CoreA
  , e :: Int
  , f :: String
  } deriving Productive(Core)

data ExtendCoreD
  = EC03A
  { Core
  , i :: Int
  , j :: String
  } deriving Productive(Core)
  | EC03B
  { k :: Int
  , l :: String
  }

-- ACoreではなく、Coreにしたいけど、一応不可能なので
instance ACore Core -- これはなくても良いならいいんだけど、そうわ行かないのかな？
instance ACore ExtendCore01
instance ACore ExtendCore02
instance ACore ExtendCore03

polyFunction1 :: ACore a => a -> (Int -> Int) -> a
polyFunction1 val f = val {a = f (a val)}

-- 本来ならば`DuplicatedRecordFields`で出来るはずだが、やや難しい。
polyFunction2 :: ACore a => a -> String
polyFunction2 val = show (a val)

simFunction1 :: ACore a => a -> a -> Int -> a
simFunction1 val param time =
  val { a = a + time * (a param)
      , b = b ++ concat . replicate time (b param)}

simFunction2 :: ACore a => a -> a
simFunction2 val =
  val { a = if (a val) > aLimit then aLimit else (a val)
      , b = if length (b val) > bLimit then take bLimit (b val) else (b val)}
  where
    aLimit = 100
    bLimit = 400
