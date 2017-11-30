# Method Swizzling 实战：Hook 系统代理方法

关于 Method Swizzling 基本用法可以先看看博主之前的文章 [浅谈 Method Swizzling](http://blog.ifelseboyxx.com/2017/01/25/Method-Swizzling/), 这里就不多做介绍了。本文以 `UIWebViewDelegate
` 为例，介绍如何利用 Method Swizzling 来 Hook 系统的 delegate 方法， 主要有如下几个步骤：

* 新建 UIWebView Category
* Hook  UIWebView 的 `delegate` 方法
* Hook  `UIWebViewDelegate` 协议中的具体方法

### Hook  UIWebView 的代理
首先，我们应该明白，当我们想 Hook 某个方法函数时，必须知道对应的 `class` ，我们这里之所以 Hook UIWebView 的 delegate，为的就是找到继承了 `UIWebViewDelegate` 协议的 `class`：

```objc
+ (void)load {
    // Hook UIWebView
    Method originalMethod = class_getInstanceMethod([UIWebView class], @selector(setDelegate:));
    Method ownerMethod = class_getInstanceMethod([UIWebView class], @selector(hook_setDelegate:));
    method_exchangeImplementations(originalMethod, ownerMethod);
}

- (void)hook_setDelegate:(id<UIWebViewDelegate>)delegate {
    
    [self hook_setDelegate:delegate];
    
}
```
> 这里我们需要注意，我们用的是 `class_getInstanceMethod
 ` 而不是 `class_getClassMethod ` ，因为 `setDelegate :` 是实例方法。另外我们这里用 `method_exchangeImplementations` 直接交换了并没有判断是因为用到 UIWebView 的页面，其 delegate 可以确定是一定实现了的。

###  Hook 协议中的具体方法

在这之前，假如我们想要 Hook `webViewDidStartLoad:` 方法，我们需要考虑这几种情况：

*  代理对象实现了 `webViewDidStartLoad:` 方法，那么我们直接交换就行。
* 代理对象如果没有实现 `webViewDidStartLoad:` 方法，而我们又想监听时，就需要我们动态的添加 `webViewDidStartLoad:` 方法。
* `setDelegate :` 万一重复设置了，会导致 `webViewDidStartLoad:` 多次交换，我们需要预防这种情况。

```objc
static void Hook_Method(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel, SEL noneSel){
    // 原实例方法
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    // 替换的实例方法
    Method replacedMethod = class_getInstanceMethod(replacedClass, replacedSel);
    // 如果没有实现 delegate 方法，则手动动态添加
    if (!originalMethod) {
        Method noneMethod = class_getInstanceMethod(replacedClass, noneSel);
        BOOL didAddNoneMethod = class_addMethod(originalClass, originalSel, method_getImplementation(noneMethod), method_getTypeEncoding(noneMethod));
        if (didAddNoneMethod) {
            NSLog(@"******** 没有实现 (%@) 方法，手动添加成功！！",NSStringFromSelector(originalSel));
        }
        return;
    }
    // 向实现 delegate 的类中添加新的方法
    // 这里是向 originalClass 的 replaceSel（@selector(owner_webViewDidStartLoad:)） 添加 replaceMethod
    BOOL didAddMethod = class_addMethod(originalClass, replacedSel, method_getImplementation(replacedMethod), method_getTypeEncoding(replacedMethod));
    if (didAddMethod) {
        // 添加成功
        NSLog(@"******** 实现了 (%@) 方法并成功 Hook 为 --> (%@)",NSStringFromSelector(originalSel) ,NSStringFromSelector(replacedSel));
        // 重新拿到添加被添加的 method,这里是关键(注意这里 originalClass, 不 replacedClass), 因为替换的方法已经添加到原类中了, 应该交换原类中的两个方法
        Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
        // 实现交换
        method_exchangeImplementations(originalMethod, newMethod);
    }else{
        // 添加失败，则说明已经 hook 过该类的 delegate 方法，防止多次交换。
        NSLog(@"******** 已替换过，避免多次替换 --> (%@)",NSStringFromClass(originalClass));
    }
}
```
```objc
- (void)hook_setDelegate:(id<UIWebViewDelegate>)delegate {
    
    [self hook_setDelegate:delegate];
    
    //Hook (webViewDidStartLoad:) 方法
    Hook_Method([delegate class], @selector(webViewDidStartLoad:), [self class], @selector(owner_webViewDidStartLoad:), @selector(none_webViewDidStartLoad:));
    
    //Hook (webViewDidFinishLoad:) 方法
    Hook_Method([delegate class], @selector(webViewDidFinishLoad:), [self class], @selector(owner_webViewDidFinishLoad:), @selector(none_webViewDidFinishLoad:));
}

- (void)owner_webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"*********** owner_webViewDidStartLoad:");
    
    [self owner_webViewDidStartLoad:webView];
    
}

- (void)none_webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"*********** none_webViewDidStartLoad:");
    
}


- (void)owner_webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"*********** owner_webViewDidFinishLoad:");
    
    [self owner_webViewDidFinishLoad:webView];
    
}

- (void)none_webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"*********** none_webViewDidFinishLoad:");
    
}
```
> 另外，不管我们是纯代码设置的 UIWebView delegate，还是通过 IB 设置的，都是没问题~


完整的代码在这里 [Demo]()

