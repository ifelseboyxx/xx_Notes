# 巧用 do...while(0) 改善代码结构

>本文所讨论的技巧都是为了避免过深的嵌套

有时候，if 和 else 的两个分支，体量是完全不对等的，尤其是在函数的开头，我们经常会对一些重要的前提条件做校验，如果校验不通过就不会做任何后续的操作：

```objc
- (NSString *)handleString:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return nil;
    }
    else {
        // 以下省略 800 字
    }
}
```
可见这个简单的判断就消耗了一个缩进，如果后续再有多个判断，代码层级就变得非常恶心，所以正确的做法如下：

```objc
- (NSString *)handleString:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return nil;
    }
    if(str.length <= 0) {
        return nil;
    }
   
    // ........ 省略多个判断
    
    // 这里开始写处理逻辑
}
```
这种做法在 Swift 面有更直接的语义，即 `guard` 关键字，相信大部分读者都知道了。

我们思考一下这里的本质，它其实是利用了 `return` 关键字提前终止了代码的执行，然而 `return` 是作用在整个函数上的，只不过可以起到阻止后续代码的执行的作用，而且恰好在这里没有副作用而已。

只是不是不好理解？没关系，看这个例子，我改两句注释：

```objc
- (NSString *)handleString:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return nil;
    }
    if(str.length <= 0) {
        return nil;
    }
   
    // ........ 省略多个判断
    
    // 第一部分逻辑依赖于前面的判断，只有判断通过的时候才执行
    // 第二部分逻辑不依赖于前面的判断，无论判断是否通过都要执行
}
```
现在的函数有两部分逻辑，如果只有第一部分逻辑，使用 `return` 毫无问题，然而第二部分逻辑要求无论是否通过前置校验都要执行，显然 `return` 关键字就不合适了。

不合适的本质原因刚刚说了，因为 `return` 影响的是整个函数的执行流程，它在第一段 demo 中能工作只是一个美丽的巧合。

如果能从这个角度去思考为什么 `return` 不行，那么解决方案就很简单了：既然 `return` 影响外层的代码块逻辑，那就构造一个临时的代码块就行了：

```objc
- (NSString *)handleString:(NSString *)str {
    do {
        if (![str isKindOfClass:[NSString class]]) {
            break;
        }
        if(str.length <= 0) {
            break;
        }
        
         // ........ 省略多个判断
        
        // 第一部分逻辑依赖于前面的判断，只有判断通过的时候才执行
        
    }while (0);
    
    // 第二部分逻辑不依赖于前面的判断，无论判断是否通过都要执行
}
```
在这个 `while` 循环里，用 `break` 就可以退出这个临时构造的代码块，也不会影响其它逻辑。


