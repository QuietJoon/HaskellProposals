Isssue
====


# Sum composition

一般化してみると、これにたどり着く。


```
data Core = A | B | C deriving Enum
data ExtendCore01 = Core | D | E deriving Enum
data ExtendCore02 = Core | F | G deriving Enum
```

上を下のように訳するのは避けるべきではないと思う。

```
data Core = A | B | C deriving Enum
data ExtendCore01 = A | B | C | D | E deriving Enum
data ExtendCore02 = A | B | C | F | G deriving Enum
```


普通に考えればSum-typeはCompositionするべきではないだろう。
もしくは、Sum-typeはSum-type同士にCompositするべきかもだが、Sum-typeの取り出しにはrecord field関係ないし、意味は無いか少ない。
特にSum-typeを組み合わせるのはdata constructorがかぶると話にならない。
よって、単純なProduct-typeのみをcompositionのcoreとするべきかもしれない。

しかし、ただSum-typeなdatatypeを組み込みの対象から除くと言うわけではない。
これはSum-Product compositionで述べることにする。
