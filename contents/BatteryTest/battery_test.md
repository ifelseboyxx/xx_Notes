# iOS 电量测试新大陆

随着 iPhone 一代又一代的更新，加上系统的电量排行榜的推出，使得用户更加关注电量问题。如果自己的 App 不小心出现在电量排行榜 Top 10 里，轻则投诉，重则卸载，这也迫使我们必须认真对待电量问题。

优化耗电问题的前提是**定位耗电**的地方。目前常用的方式要么操作后直接去系统的电量排行榜里看耗电百分比，要么就是借助 instrments 中的 Energy Log，虽说还有电量测试仪这种硬件测试方式，但是成本太高。所以，常用的还是 instrments 搭配系统电量排行榜，一个排除问题，一个统计对比数据。具体如何使用 instrments 来测试，大家可以看看这篇文章 [iOS 常见耗电量检测方案调研](https://github.com/ChenYilong/iOSBlog/issues/10)。

除了上面的方法，其实还有一种更好的办法：[sysdiagnose](https://developer.apple.com/bug-reporting/profiles-and-logs/?platform=ios)。通过这种方式，我们可以获取电量消耗，电压，电流，温度，甚至系统的 CPU、GPU 等等耗电都有详细的数据。而且不单单是自己的 App，手机内安装的其它的  APP 同样可以获取到数据，这样大大方便了我们做出详细的对比测试数据。由于这些都是苹果系统的数据，可靠性还是比较有保障的。废话不多说，我们来看看步骤：

## 数据获取方式

* 官网下载证书 [Profiles and Logs](https://developer.apple.com/bug-reporting/profiles-and-logs/?platform=ios)。

    ![](http://p0kmbfoc8.bkt.clouddn.com/profiles_battery.png)
    
* 下载完成后通过 AirDrop 发到测试手机上安装。
* 在不重启手机的情况下，等待10到30分钟。
* 手机连上电脑，通过 iTunes 同步到电脑上。
* 去 `~/Library/Logs/CrashReporter/MobileDevice` 目录下，打开 powerlog_xxxx.PLSQL 文件。

    ![](http://p0kmbfoc8.bkt.clouddn.com/table.png)


我们可以看到，powerlog_xxxx.PLSQL 是个相当庞大的文件，里面有几百张表，所有的电量数据都在里面。主要的几张表的意思如下：


|表名 | 内容 |
| --- | --- | 
| PLBatteryAgent_EventBackward_Battery | 整台机器的电量数据，包含电流、电压、温度等，每 20 秒 左右一条数据 | 
| PLBatteryAgent_EventBackward_BatteryUI | 电量百分比数据，每 20 秒一条数据 |
| PLIOReportAgent_EventBackward_EneryModel  |  整机的详细电量数据。包含 CPU\GPU\DRAM\ISP 等关键信息。每半小时到一小时一条数据。 |
| PLAccountingOperator_EventNone_Nodes | App 结点信息，每个 APP 对应唯一的结点号。用来确定手机内具体哪个 App。 |
| PLApplicationAgent_EventForward_Application  | App 运行信息，记录每个 App 在哪个时间段以什么状态运行 |
| PLAppTimeService_Aggregate_AppRunTime  | APP 的运行时长统计，每个运行过的 APP，一小时一条数据 |
| PLAccountingOperator_Aggregate_RootNodeEnergy | APP 的电量详细数据，记录每个 APP 的CPU\GPU\DRAM\ISP 等的耗电信息。一小时更新一次数据。|

## 测试方式

正常我们可以分模块测试，比如我们的 APP 有模块 A、B、C，三个模块，我们可以在固定的时间内只测试一个模块。比如三十分钟内，只测试 A 模块，因为电量数据是一小时更新一次的，所以我们尽量在一小时内把需要测试的模块测试完毕。然后下一个一小时，测试模块 B，以此类推。最后按照上面一节的方式先把数据取下来，接着先去 `PLAccountingOperator_EventNone_Nodes` 表中，找到我们 APP 的结点标识，比如下图中，是我自己手机里的去哪儿，飞猪，途牛等 APP 的唯一标识：

![](http://p0kmbfoc8.bkt.clouddn.com/node.png)

其实可以发现，表中对应的 `Name` 字段就是 `Bundle Identifier`，至于怎么知道自己手机里其它 App  的 `Bundle Identifier`，可以通过 [PP助手](http://pro.25pp.com/)，下载，解压安装包里的 `.ipa` 包里的 `info.plist` 来获取。

得到每个 App 的唯一标识后，我们就可以去 `PLAccountingOperator_Aggregate_RootNodeEnergy biao` 表里看电量消耗数据了：

![](http://p0kmbfoc8.bkt.clouddn.com/energy.png)
 
表中的 `Energy` 就是对应消耗的电量了，**这里的单位在 iOS 9 是 `mAh`，iOS 9 及以上应该是 `1/1000 mAh`**。这段时间内的耗电量，我们也就可以执行 SQL 语句计算出来：

![](http://p0kmbfoc8.bkt.clouddn.com/sql.png)

比如这个耗电量为 `96454 / 1000 = 96.454 mAh`。

如果我们还想知道运行这个 App 这段时间内的温度，也可以去 `PLBatteryAgent_EventBackward_Battery` 表中获取，但是因为该表的数据是整个机器的，所以我们需要根据对应的时间节点来观察数据：

![](http://p0kmbfoc8.bkt.clouddn.com/temperature.png)

是不是很酷？有了这些官方数据支撑，能更加方便我们测试！

## 参考文献

https://cloud.tencent.com/community/article/877849
https://github.com/ChenYilong/iOSBlog/issues/10




