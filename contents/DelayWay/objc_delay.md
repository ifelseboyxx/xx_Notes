# Objective-C 中延迟执行和取消  


在 Objective-C 中延迟执行还是很常见的需求，通常有如下几种方式可供选择：

## performSelector：

想要延迟调用某个方法：

```objc
[self performSelector:@selector(delay) withObject:nil afterDelay:3.0];
```

取消延迟的方法：

```objc
[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delay) object:nil];
```
> 这里需要注意参数需要保持一致，否则取消失败。

## NSTimer

想要延迟调用某个方法：

```objc
self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(delay) userInfo:nil repeats:NO];
```

取消延迟的方法：

```objc
[self.timer invalidate];
```

## GCD

```objc
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // ...
});
```

`dispatch_after` 是比较常用的方法，但是 Objective-C 中并没有提供取消执行的相关 API。我们只能自己实现这个取消的逻辑：

```objc
typedef void (^Task)(BOOL cancel);
Task delay(NSTimeInterval time,void (^task)()) {
    __block void (^closure)() = task;
    __block Task result;
    Task delayedClosure = ^(BOOL cancel){
        if (closure) {
            void (^internalClosure)() = closure;
            if (!cancel) {
                dispatch_async(dispatch_get_main_queue(), internalClosure);
            }
        }
        closure = nil;
        result = nil;
    };
    
    result = delayedClosure;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (delayedClosure) {
            delayedClosure(NO);
        }
    });
    return result;
}
```

使用的话可以这样：

```objc
delay(60, ^{
    // ...
});
```

如果想要延迟，可以先声明成成员变量并赋值：

```objc
@property (copy, nonatomic) Task task;
```
```objc
self.task = delay(60, ^{
    // ...
});
```

最后在需要的地方取消就行：

```objc
self.task(YES);
```

> 这种写法的核心思想是根据传入的 `Bool` 值，来控制 `dispatch_after` 回调 `block` 中的方法是否需要执行。看起来是取消了，但实际上还是被 GCD 放到 RunLoop 里去占用主线程资源了。

## dispatch_source

我们还可以利用 `dispatch_source` 中的定时器，来实现延时／取消操作：

```objc
@property (strong, nonatomic) dispatch_source_t timer;
```
```objc
// 队列
dispatch_queue_t queue = dispatch_get_main_queue();
// 创建 dispatch_source
dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
// 声明成员变量
self.timer = timer;
// 设置两秒后触发
dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
// 设置下次触发事件为 DISPATCH_TIME_FOREVER
dispatch_time_t nextTime = DISPATCH_TIME_FOREVER;
// 设置精确度
dispatch_time_t leeway = 0.1 * NSEC_PER_SEC;
// 配置时间
dispatch_source_set_timer(timer, startTime, nextTime, leeway);
// 回调
dispatch_source_set_event_handler(timer, ^{
    // ...
});
// 激活
dispatch_resume(timer);
```

需要取消的话：

```objc
dispatch_source_cancel(self.timer);
```


