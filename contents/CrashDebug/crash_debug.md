# iOS crash 日志堆栈解析（符号化）

日常开放中，我们难免遇到一些 crash。大部分情况下，Xcode 可以帮助我们找到问题所在，但也有些情况，Xcode 给我们反馈的是一些看不懂的地址，大大增加了我们分析问题的难度。

下面，就来介绍几种能让看不懂的地址，变得看的懂的方式。

## symbolicatecrash

###  .dSYM 文件

dSYM 是保存十六进制函数地址映射信息的中转文件，我们调试的 symbols 都会包含在这个文件中。每次编译项目的时候都会生成一个新的 dSYM 文件，**我们应该保存每个正式发布版本的 dSYM 文件，以备我们更好的调试问题**。一般是在我们 Archives 时保存对应的版本文件的，里面也有对应的 `.dSYM` 和 `.app` 文件。路径为：

```
~/Library/Developer/Xcode/Archives
```

**`.dSYM` 文件默认在 debug 模式下是不生成的**，我们去 Build Settings -> Debug Information Format 下，将 `DWARF` 修改为 `DWARF with dSYM File`，再重新编译下就能生成 `.dSYM` 文件了，直接去项目工程的 `Products` 目录下找就行。

#### symbols 又是什么呢？

引用 《程序员的自我修养》中的解释：

> 在链接中，我们将函数和变量统称为符号（Symbol），函数名或变量名就是符号名（Symbol Name）。我们可以将符号看作是链接中的粘合剂，整个链接过程正是基于符号才能够正确完成。

所以，所谓的 symbols 就是**函数名或变量名**。

### 找到 symbolicatecrash

`symbolicatecrash` 是 Xcode 自带的 crash 日志分析工具，我们需要先找到它：

```
find /Applications/Xcode.app -name symbolicatecrash -type f
```
执行完后会返回几个路径，我的是：
```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/PrivateFrameworks/DVTFoundation.framework/symbolicatecrash
```

我们到这个路径下把 `symbolicatecrash` 拷贝出来，放到一个文件夹下。

### 拿到 crash 日志文件

我们可以随便写段强制 crash 的代码：

```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	NSArray *arr = @[];
	arr[100];
}
```

接着用**真机**打个包。打好包之后，**不要用 Xcode build**，**直接用打好的包运行我们能导致 crash 的代码**，这样就生成好 `.crash ` 日志文件了。

之后，我们去 Xcode -> Window -> Devices and Simulators 或者快捷键 **Command + Shift + 2**

![](http://p0kmbfoc8.bkt.clouddn.com/crash_find.png)

找到对应时间点的 .crash 文件，右击 Export Log。

### 拿到 .app 文件

`.app` 文件可以使用真机编译下，去 项目 `Products`  目录下获取，也可以去 Archives 目录下获取。

### 符号解析

#### 利用 dSYM

将 `.dSYM` 、`.crash` 及 `symbolicatecrash` 放到同一个文件下，执行命令：

```
./symbolicatecrash .crash文件路径 .dSYM文件路径 > 名字.crash
```

#### 利用 app

将 `.app` 、`.crash` 及 `symbolicatecrash` 放到同一个文件下，执行命令：

```
./symbolicatecrash .crash文件路径 .app/appName 路径 > 名字.crash
```

可能会报错误：

```
Error: "DEVELOPER_DIR" is not defined at ./symbolicatecrash line 69.
```

执行下命令就行：

```
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
```

然后再重新生成下新的 `.crash` 文件就行。

我们可以对比下没有符号化和符号化的文件，下面是我自己测试的例子，`iPhone5 iOS 10.2`， 可能会有所不同：

```
Last Exception Backtrace:
0   CoreFoundation                	0x1df60df2 __exceptionPreprocess + 126
1   libobjc.A.dylib               	0x1d1c3072 objc_exception_throw + 33
2   CoreFoundation                	0x1dee62f2 -[__NSArray0 objectAtIndex:] + 105
3   DreamDemo                     	0x0008088e 0x7c000 + 18574
4   UIKit                         	0x2319eb44 forwardTouchMethod + 289
5   UIKit                         	0x2319ea10 -[UIResponder touchesBegan:withEvent:] + 29
6   UIKit                         	0x23041c58 -[UIWindow _sendTouchesForEvent:] + 1599
7   UIKit                         	0x2303ca62 -[UIWindow sendEvent:] + 2657
8   UIKit                         	0x2300d870 -[UIApplication sendEvent:] + 315
9   UIKit                         	0x237a8998 __dispatchPreprocessedEventFromEventQueue + 2615
10  UIKit                         	0x237a25de __handleEventQueue + 829
11  CoreFoundation                	0x1df1c716 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 7
12  CoreFoundation                	0x1df1c220 __CFRunLoopDoSources0 + 433
13  CoreFoundation                	0x1df1a4f6 __CFRunLoopRun + 757
14  CoreFoundation                	0x1de6952e CFRunLoopRunSpecific + 481
15  CoreFoundation                	0x1de6933c CFRunLoopRunInMode + 99
16  GraphicsServices              	0x1f640bf8 GSEventRunModal + 151
17  UIKit                         	0x230789a2 -[UIApplication _run] + 569
18  UIKit                         	0x230730cc UIApplicationMain + 145
19  DreamDemo                     	0x000834cc 0x7c000 + 29900
20  libdyld.dylib                 	0x1d633506 _dyld_process_info_notify_release + 23
```
问题也能看出来，但是因为第三行（DreamDemo）并没有符号化，**导致我们并不确定具体调用位置。**

再来看看符号化之后的：

```
Last Exception Backtrace:
0   CoreFoundation                	0x1df60df2 __exceptionPreprocess + 126
1   libobjc.A.dylib               	0x1d1c3072 objc_exception_throw + 33
2   CoreFoundation                	0x1dee62f2 -[__NSArray0 objectAtIndex:] + 105
3   DreamDemo                     	0x0008088e -[ViewController touchesBegan:withEvent:] + 18574 (ViewController.m:84)
4   UIKit                         	0x2319eb44 forwardTouchMethod + 289
5   UIKit                         	0x2319ea10 -[UIResponder touchesBegan:withEvent:] + 29
6   UIKit                         	0x23041c58 -[UIWindow _sendTouchesForEvent:] + 1599
7   UIKit                         	0x2303ca62 -[UIWindow sendEvent:] + 2657
8   UIKit                         	0x2300d870 -[UIApplication sendEvent:] + 315
9   UIKit                         	0x237a8998 __dispatchPreprocessedEventFromEventQueue + 2615
10  UIKit                         	0x237a25de __handleEventQueue + 829
11  CoreFoundation                	0x1df1c716 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 7
12  CoreFoundation                	0x1df1c220 __CFRunLoopDoSources0 + 433
13  CoreFoundation                	0x1df1a4f6 __CFRunLoopRun + 757
14  CoreFoundation                	0x1de6952e CFRunLoopRunSpecific + 481
15  CoreFoundation                	0x1de6933c CFRunLoopRunInMode + 99
16  GraphicsServices              	0x1f640bf8 GSEventRunModal + 151
17  UIKit                         	0x230789a2 -[UIApplication _run] + 569
18  UIKit                         	0x230730cc UIApplicationMain + 145
19  DreamDemo                     	0x000834cc main + 29900 (main.m:15)
20  libdyld.dylib                 	0x1d633506 _dyld_process_info_notify_release + 23
```

可以发现，第三行被解析出来了，这样我们就能很清晰的知道具体的页面了。

##  使用命令行工具 atos

symbolicatecrash 可以帮助我们很好的分析 crash 日志，但是有它的局限性 --- 不够灵活。我们需要 `symbolicatecrash `、`.crash` 及 `.dSYM`  三个文件才能解析。

相对于 symbolicatecrash， `atos` 命令更加灵活，特别是你需要对不同渠道的 crash 文件，写一个自动化的分析脚本的时候，这个方法就极其有用。

但是这种方式也有个不方便的地方：一个线上的 App，用户使用的版本存在差异，而每个版本所对应的 `.dSYM` 都是不同的。**必须确保 `.crash` 和 `.dSYM` 文件是匹配的**，才能正确符号化，**匹配的条件就是它们的 UUID 一致**。
在这之前，先介绍下 UUID：

### 什么是 UUID ?

UUID 是由一组 32 位数的十六进制数字所构成。每一个可执行程序都有一个 build UUID 唯一标识。`.crash`日志包含发生 crash 的这个应用的 build UUID 以及 crash 发生时，应用加载的所有库文件的 build UUID。

### 获取 UUID 

#### .crash UUID

执行命令：

```
grep --after-context=2 "Binary Images:" *crash
```

输出：

```
T.crash:Binary Images:
T.crash-0x7c000 - 0x87fff DreamDemo armv7  <d009f8671129397a8aab9cb2b8e506ff> /var/containers/Bundle/Application/DEEBE571-D512-4E8F-B712-ED4D19CE64F9/DreamDemo.app/DreamDemo
T.crash-0xa9000 - 0xd4fff dyld armv7s  <cd60ff3403063c0aa8e54dff11e42527> /usr/lib/dyld
```

看到上面的输出 `d009f8671129397a8aab9cb2b8e506ff` 就是 `DreamDemo` 项目的 UUID。

#### .dSYM UUID

执行命令：

```
dwarfdump --uuid DreamDemo.app.dSYM
```

输出：

```
UUID: D009F867-1129-397A-8AAB-9CB2B8E506FF (armv7) DreamDemo.app.dSYM/Contents/Resources/DWARF/DreamDemo
```

#### .app UUID

执行命令：

```
dwarfdump --uuid DreamDemo.app/DreamDemo
```

输出：

```
UUID: D009F867-1129-397A-8AAB-9CB2B8E506FF (armv7) DreamDemo.app/DreamDemo
```

**可以发现这两个文件的 UUID 是相同的，也就是匹配的，只有满足这种条件，才能正确的解析！**

#### atos 解析

我们现回顾下未解析前的堆栈：

```
2   CoreFoundation                	0x1dee62f2 -[__NSArray0 objectAtIndex:] + 105
3   DreamDemo                     	0x0008088e 0x7c000 + 18574
4   UIKit                         	0x2319eb44 forwardTouchMethod + 289
5   UIKit                         	0x2319ea10 -[UIResponder touchesBegan:withEvent:] + 29
```

执行命令：

```
xcrun atos -o DreamDemo.app.dSYM/Contents/Resources/DWARF/DreamDemo -arch armv7 -l 0x7c000
```

接着输入 `0x0008088e` 地址，终端输出如下：

![](http://p0kmbfoc8.bkt.clouddn.com/cmd.png)

可以发现，正确的解析出来了！

**除了搭配 `.dSYM` 文件，我们也可以使用 `.app` 文件来解析：**

执行命令：

```
xcrun atos -o DreamDemo.app/DreamDemo -arch armv7 -l 0x7c000
```

同样输入 `0x0008088e` 地址，效果是一样的。

### 工具

直接操作 `atos` 命令毕竟是有点不方便，GitHub 上有个工具，可以辅助我们解析 [dSYMTools](https://github.com/answer-huang/dSYMTools) ，这是个 Mac 客户端，界面长这样：

![](http://p0kmbfoc8.bkt.clouddn.com/tool.png)

使用起来也很方便，我们只需要把对应的 `dSYM` 文件拖进去，它会自动识别 UUID。我们对应的输入参数地址就行：

![](http://p0kmbfoc8.bkt.clouddn.com/tool_show.png)

## 系统库的符号化解析

细心的人可以发现，我们上面的解析都是针对 `DreamDemo` ，这个自己的项目的。其实很多系统方法的堆栈之所以能解析出来，是因为已经有了系统库的符号化文件，存放目录如下：

```
/用户/用户名称xxx/资源库/Developer/Xcode/iOS DeviceSupport
```

![](http://p0kmbfoc8.bkt.clouddn.com/file.png)

这些库的版本都是和 `.crash` 文件中是对应的：

```
OS Version:          iPhone OS 10.2 (14C5077b)
```

一旦我把这个 `10.2 (14C5077b)` 系统的符号化库删掉，`.crash` 文件就会变成这样：

```
Last Exception Backtrace:
0   CoreFoundation                	0x1df60df2 0x1de5f000 + 1056242
1   libobjc.A.dylib               	0x1d1c3072 0x1d1bc000 + 28786
2   CoreFoundation                	0x1dee62f2 0x1de5f000 + 553714
3   DreamDemo                     	0x000bc66e -[ViewController touchesBegan:withEvent:] + 18030 (ViewController.m:78)
4   UIKit                         	0x2319eb44 0x22ffe000 + 1706820
5   UIKit                         	0x2319ea10 0x22ffe000 + 1706512
6   UIKit                         	0x23041c58 0x22ffe000 + 277592
7   UIKit                         	0x2303ca62 0x22ffe000 + 256610
8   UIKit                         	0x2300d870 0x22ffe000 + 63600
9   UIKit                         	0x237a8998 0x22ffe000 + 8038808
10  UIKit                         	0x237a25de 0x22ffe000 + 8013278
11  CoreFoundation                	0x1df1c716 0x1de5f000 + 775958
12  CoreFoundation                	0x1df1c220 0x1de5f000 + 774688
13  CoreFoundation                	0x1df1a4f6 0x1de5f000 + 767222
14  CoreFoundation                	0x1de6952e 0x1de5f000 + 42286
15  CoreFoundation                	0x1de6933c 0x1de5f000 + 41788
16  GraphicsServices              	0x1f640bf8 0x1f637000 + 39928
17  UIKit                         	0x230789a2 0x22ffe000 + 502178
18  UIKit                         	0x230730cc 0x22ffe000 + 479436
19  DreamDemo                     	0x000bf332 main + 29490 (main.m:15)
20  libdyld.dylib                 	0x1d633506 0x1d630000 + 13574
```

可以明显的发现，系统库的堆栈变成了一堆地址。

新版本，每当我们手机连上 Xcode 时，都会把当前版本的系统符号库自动导入到 `/用户/用户名称xxx/资源库/Developer/Xcode/iOS DeviceSupport` 目录下。但是 iOS 版本那么多，之前旧的系统符号库该怎么获取呢？有人已经整理好了 [iOS-System-Symbols](https://github.com/Zuikyo/iOS-System-Symbols)，我们只需要根据 `.crash` 文件的版本信息，下载对应的系统符号化文件到目录下即可。

## 总结

* 利用 symbolicatecrash 解析，可以将整个 `.crash` 日志堆栈解析，但是由于依赖 `symbolicatecrash`、`.crash` 以及 `.dSYM` 三个文件，或者 `.app` 、`.crash` 及 `symbolicatecrash` 三个文件，导致不太灵活。
* 利用 `atos` 命令只需要 `.crash`和 `.dSYM` ，或者 `.crash`和 `.app`，知道对应的堆栈地址，就能解析，方便自动化脚本分析，但是 crash 堆栈可能需要自己实现收集。

## 参考

[http://wufawei.com/2014/03/symbolicating-ios-crash-logs/](http://wufawei.com/2014/03/symbolicating-ios-crash-logs/)


