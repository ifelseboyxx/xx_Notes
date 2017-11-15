#  iOS 开发中的八种锁（Lock）

这两天翻看 ibireme 大神 《[不再安全的 OSSpinLock](http://blog.ibireme.com/)》 这篇文章，看到文中分析各种锁之前的性能的图表：

![lock_benchmark.png](http://upload-images.jianshu.io/upload_images/1899027-eb3ef0d444034362.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

发现除了 `@synchronized` 用过,其他的都陌生的很，可以说完全不知道啥玩意儿~

![](http://upload-images.jianshu.io/upload_images/1899027-6959b9f6823f26bb.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

于是怀着惭愧的心情赶紧把这些锁学习了下，废话不多说，我们开始:

## 锁 是什么意思？
我们在使用多线程的时候多个线程可能会访问同一块资源，这样就很容易引发数据错乱和数据安全等问题，这时候就需要我们保证每次只有一个线程访问这一块资源，**锁** 应运而生。

### OSSpinLock 

需导入头文件:
```objc
#import <libkern/OSAtomic.h>
```

例子：

```objc
__block OSSpinLock oslock = OS_SPINLOCK_INIT;
//线程1  
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        OSSpinLockLock(&oslock);
        sleep(4);
        NSLog(@"线程1");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程1 解锁成功");
        NSLog(@"--------------------------------------------------------");
    });
    
//线程2
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        OSSpinLockLock(&oslock);
        NSLog(@"线程2");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程2 解锁成功");
    });
```

运行结果：

![OSSpinLock1](http://upload-images.jianshu.io/upload_images/1899027-da0bbfd046fc7e30.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们来修改一下代码：
```objc
__block OSSpinLock oslock = OS_SPINLOCK_INIT;
//线程1        
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
......
//OSSpinLockUnlock(&oslock);
......
```

运行结果：

![OSSpinLock2](http://upload-images.jianshu.io/upload_images/1899027-5f6aeebcb8d9cb00.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


在  `OSSpinLock1` 图中可以发现：当我们锁住线程1时，在同时锁住线程2的情况下，线程2会一直等待**（自旋锁不会让等待的进入睡眠状态）**，直到线程1的任务执行完且解锁完毕，线程2会立即执行；而在 `OSSpinLock2` 图中，因为我们注释掉了线程1中的解锁代码，会绕过线程1，直到调用了线程2的解锁方法才会继续执行线程1中的任务，**正常情况下，`lock`和`unlock`最好成对出现**。

>**OS_SPINLOCK_INIT：** 默认值为 `0`,在 `locked` 状态时就会大于 `0`，`unlocked`状态下为 `0`
>**OSSpinLockLock(&oslock)：**上锁，参数为 `OSSpinLock` 地址
>**OSSpinLockUnlock(&oslock)：**解锁，参数为 `OSSpinLock` 地址
>**OSSpinLockTry(&oslock)**：尝试加锁，可以加锁则**立即加锁**并返回 `YES`,反之返回 `NO`

这里顺便提一下 `trylock` 和 `lock` 使用场景：
>当前线程锁失败，也可以继续其它任务，用 trylock 合适
>当前线程只有锁成功后，才会做一些有意义的工作，那就 lock，没必要轮询 trylock

#### dispatch_semaphore 信号量
****
例子：
```objc
dispatch_semaphore_t signal = dispatch_semaphore_create(1); //传入值必须 >=0, 若传入为0则阻塞线程并等待timeout,时间到后会执行其后的语句
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);

//线程1
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 等待ing");
        dispatch_semaphore_wait(signal, overTime); //signal 值 -1
        NSLog(@"线程1");
        dispatch_semaphore_signal(signal); //signal 值 +1
        NSLog(@"线程1 发送信号");
        NSLog(@"--------------------------------------------------------");
    });
    
//线程2
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 等待ing");
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"线程2");
        dispatch_semaphore_signal(signal);
        NSLog(@"线程2 发送信号");
    });
```

>**dispatch_semaphore_create(1)：** 传入值必须 `>=0`, 若传入为 `0` 则阻塞线程并等待timeout,时间到后会执行其后的语句
>**dispatch_semaphore_wait(signal, overTime)：**可以理解为 `lock`,会使得 `signal` 值 `-1`
>**dispatch_semaphore_signal(signal)：**可以理解为 `unlock`,会使得 `signal` 值 `+1`

关于信号量，我们可以用停车来比喻：

> 停车场剩余4个车位，那么即使同时来了四辆车也能停的下。如果此时来了五辆车，那么就有一辆需要等待。
> **信号量的值（signal）**就相当于剩余车位的数目，`dispatch_semaphore_wait` 函数就相当于来了一辆车，`dispatch_semaphore_signal` 就相当于走了一辆车。停车位的剩余数目在初始化的时候就已经指明了（dispatch_semaphore_create（long value）），调用一次 dispatch_semaphore_signal，剩余的车位就增加一个；调用一次 dispatch_semaphore_wait  剩余车位就减少一个；当剩余车位为 0 时，再来车（即调用 dispatch_semaphore_wait）就只能等待。有可能同时有几辆车等待一个停车位。有些车主没有耐心，给自己设定了一段等待时间，这段时间内等不到停车位就走了，如果等到了就开进去停车。而有些车主就像把车停在这，所以就一直等下去。

运行结果：

![初始信号量大于0](http://upload-images.jianshu.io/upload_images/1899027-e45133dc53c7b53d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以发现，因为我们初始化信号量的时候是大于 `0` 的，所以并没有阻塞线程，而是直接执行了 线程1 线程2。

我们把 信号量初始值改为 `0`:

```objc
dispatch_semaphore_t signal = dispatch_semaphore_create(0);
```

运行结果:

![初始信号量为0](http://upload-images.jianshu.io/upload_images/1899027-378750ef97bd0959.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到这时候我们设置的 `overTime` 生效了。

#### pthread_mutex 
****
ibireme 在《[不再安全的 OSSpinLock](http://blog.ibireme.com/)》这篇文章中提到性能最好的 `OSSpinLock` 已经不再是线程安全的并把自己开源项目中的 `OSSpinLock` 都替换成了 `pthread_mutex`。
特意去看了下源码，总结了下常见用法：

使用需导入头文件：

```objc
#import <pthread.h>
```

例子:

```objc
static pthread_mutex_t pLock;
pthread_mutex_init(&pLock, NULL);
//1.线程1
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        pthread_mutex_lock(&pLock);
        sleep(3);
        NSLog(@"线程1");
        pthread_mutex_unlock(&pLock);
    });
    
//1.线程2
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        pthread_mutex_lock(&pLock);
        NSLog(@"线程2");
        pthread_mutex_unlock(&pLock);
    });
```

运行结果:

![pthread_mutex](http://upload-images.jianshu.io/upload_images/1899027-f051bcdb173e8612.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> pthread_mutex 中也有个 `pthread_mutex_trylock(&pLock)`，和上面提到的 `OSSpinLockTry(&oslock)` 区别在于，前者可以加锁时返回的是 `0`，否则返回一个错误提示码；后者返回的 `YES`和 `NO`。

这里贴个  [YYKit](https://github.com/ibireme/YYKit) 中的源码：

![YYKit](http://upload-images.jianshu.io/upload_images/1899027-48d96143d13a9371.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### pthread_mutex(recursive) 
****
经过上面几种例子，我们可以发现：加锁后只能有一个线程访问该对象，后面的线程需要排队，并且 lock 和 unlock 是对应出现的，同一线程多次 lock 是不允许的，而递归锁允许同一个线程在未释放其拥有的锁时反复对该锁进行加锁操作。

例子:
```objc
static pthread_mutex_t pLock;
pthread_mutexattr_t attr;
pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
pthread_mutex_init(&pLock, &attr);
pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用

//1.线程1
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            pthread_mutex_lock(&pLock);
            if (value > 0) {
                NSLog(@"value: %d", value);
                RecursiveBlock(value - 1);
            }
            pthread_mutex_unlock(&pLock);
        };
        RecursiveBlock(5);
    });
```

运行结果:

![结果](http://upload-images.jianshu.io/upload_images/1899027-ed159b5987a9aaed.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 上面的代码如果我们用 `pthread_mutex_init(&pLock, NULL)` 初始化会出现死锁的情况，递归锁能很好的避免这种情况的死锁；

### NSLock 

NSLock API 很少也很简单:

![NSLock](http://upload-images.jianshu.io/upload_images/1899027-fd930ccf5d969f6f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>**lock、unlock**：不多做解释，和上面一样
>**trylock**：能加锁返回 YES 并执行**加锁**操作，相当于 lock，反之返回 NO
>** lockBeforeDate：**这个方法表示会在传入的时间内尝试加锁，若能加锁则执行**加锁**操作并返回 YES，反之返回 NO

例子:
```objc
NSLock *lock = [NSLock new];
//线程1
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 尝试加速ing...");
        [lock lock];
        sleep(3);//睡眠5秒
        NSLog(@"线程1");
        [lock unlock];
        NSLog(@"线程1解锁成功");
    });
//线程2
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 尝试加速ing...");
        BOOL x =  [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:4]];
        if (x) {
            NSLog(@"线程2");
            [lock unlock];
        }else{
            NSLog(@"失败");
        }
    });
```

运行结果:

![NSLock_result](http://upload-images.jianshu.io/upload_images/1899027-471bcb7fcc0bcfea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### NSCondition

我们先来看看 API：

![NSCondition](http://upload-images.jianshu.io/upload_images/1899027-231a3255007492fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

看字面意思很好理解:
>**wait**：进入等待状态
>**waitUntilDate:**：让一个线程等待一定的时间
>**signal**：唤醒一个等待的线程
>**broadcast**：唤醒所有等待的线程

例子:

* **等待2秒**

```objc
NSCondition *cLock = [NSCondition new];
//线程1
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start");
        [cLock lock];
        [cLock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        NSLog(@"线程1");
        [cLock unlock];
    });
```

结果:

![waiting 2秒](http://upload-images.jianshu.io/upload_images/1899027-7ff9328f53551846.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* **唤醒一个等待线程**

```objc
NSCondition *cLock = [NSCondition new];
//线程1
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        NSLog(@"线程1加锁成功");
        [cLock wait];
        NSLog(@"线程1");
        [cLock unlock];
    });
    
//线程2
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        NSLog(@"线程2加锁成功");
        [cLock wait];
        NSLog(@"线程2");
        [cLock unlock];
    });

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        NSLog(@"唤醒一个等待的线程");
        [cLock signal];
    });
```

结果:

![唤醒一个等待的线程](http://upload-images.jianshu.io/upload_images/1899027-e587d966e6f34c92.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


* **唤醒所有等待的线程**

```objc
.........    
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        NSLog(@"唤醒所有等待的线程");
        [cLock broadcast];
    });
```

运行结果:

![唤醒所有的线程](http://upload-images.jianshu.io/upload_images/1899027-f7c07e6e2c031088.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### NSRecursiveLock 

上面已经大概介绍过了：
递归锁可以被同一线程多次请求，而不会引起死锁。这主要是用在循环或递归操作中。

例子：

```objc
NSLock *rLock = [NSLock new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            [rLock lock];
            if (value > 0) {
                NSLog(@"线程%d", value);
                RecursiveBlock(value - 1);
            }
            [rLock unlock];
        };
        RecursiveBlock(4);
    });
```

运行结果:

![错误信息](http://upload-images.jianshu.io/upload_images/1899027-9502f58fa9244b5f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这段代码是一个典型的死锁情况。在我们的线程中，`RecursiveMethod` 是递归调用的。所以每次进入这个 block 时，都会去**加一次锁**，而从第二次开始，由于锁已经被使用了且**没有解锁**，所以它**需要等待锁被解除**，这样就导致了死锁，线程被阻塞住了。

将 NSLock 替换为 NSRecursiveLock：

```objc
NSRecursiveLock *rLock = [NSRecursiveLock new];
..........
```
运行结果:

![NSRecursiveLock](http://upload-images.jianshu.io/upload_images/1899027-58b8575d0ba80cb3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

NSRecursiveLock 方法里还提供了两个方法，用法和上面介绍的基本没什么差别，这里不过多介绍了：

```objc
- (BOOL)tryLock;
- (BOOL)lockBeforeDate:(NSDate *)limit;
```

### @synchronized 

@synchronized 相信大家应该都熟悉，它的用法应该算这些锁中最简单的:

```objc
//线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            sleep(2);
            NSLog(@"线程1");
        }
    });
    
//线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            NSLog(@"线程2");
        }
    });
    
```

>有兴趣可以看一下这篇文章 《 [关于 @synchronized，这儿比你想知道的还要多](http://ios.jobbole.com/82826/)》

### NSConditionLock 条件锁

我们先来看看 API :

![NSConditionLock](http://upload-images.jianshu.io/upload_images/1899027-95362ad47a95575c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

相比于 NSLock 多了个 `condition` 参数，我们可以理解为一个**条件标示**。

例子:

```objc
NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];
//线程1

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([cLock tryLockWhenCondition:0]){
            NSLog(@"线程1");
           [cLock unlockWithCondition:1];
        }else{
             NSLog(@"失败");
        }
    });
    
//线程2
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:3];
        NSLog(@"线程2");
        [cLock unlockWithCondition:2];
    });
    
//线程3
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:1];
        NSLog(@"线程3");
        [cLock unlockWithCondition:3];
    });
```

运行结果:

![result](http://upload-images.jianshu.io/upload_images/1899027-7e410aff9dba4060.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 我们在初始化 NSConditionLock 对象时，给了他的标示为 `0`
* 执行 `tryLockWhenCondition:` 时，我们传入的条件标示也是 `0`,所 **以线程1** 加锁成功
* 执行 `unlockWithCondition:` 时，**这时候会把 `condition` 由 `0` 修改为 `1` **
* 因为 `condition`  修改为了  `1`， 会先走到 **线程3**，然后 **线程3** 又将 `condition` 修改为 `3`
* 最后 走了 **线程2** 的流程

>从上面的结果我们可以发现，NSConditionLock 还可以实现任务之间的依赖。

### 参考文献:

[NSRecursiveLock递归锁的使用](http://www.cocoachina.com/ios/20150513/11808.html)

[关于dispatch_semaphore的使用](http://www.cnblogs.com/snailHL/p/3906112.html)

[实现锁的多种方式和锁的高级用法](http://www.cnblogs.com/huangjianwu/p/4575763.html)
