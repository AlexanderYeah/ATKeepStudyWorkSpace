# RunLoop
运行循环，程序的运行全依赖于RunLoop
主要负责：

* 1 使程序一直运行并接受用户输入  
* 2 决定程序在何时处理一些Event
* 3 节省CPU时间（没事的时候闲着，有事的时候处理）
* 4 调用解耦(Message Queue)


NSRunLoop 是对 CFRunLoop 的封装。
CFRunLoopMode 包含 CFRunLoopSource CFRunLoopTimer CFRunLoopObserver 

## 一 CFRunLoopTimer   

系统提供的NSTimer、CADisplayLink、performSelector等都是对CFRunLoopTimer的封装。

## 二 CFRunLoopSource   
RunLoop定义了两个版本的Source,分别是Source0和Source1。

1 Source0：处理APP内部事件、APP自己负责管理(触发)，如UIEvent、CFSocket  
2 Source1：由RunLoop和内核管理，Mach Port驱动，如CFMachPort、CFMessagePort

* CFRunLoopObserver 观察者，向外部报告RunLoop当前状态的更改  

* kCFRunLoopEntry // 即将进入Loop
* kCFRunLoopBeforeTimers // 即将处理Timer
* kCFRunLoopBeforeSources // 即将处理Source  
* kCFRunLoopBeforeWaiting // 即将进入休眠
* kCFRunLoopAfterWaiting // 刚从休眠中唤醒  
* kCFRunLoopExit // 即将推出Loop

## 三 CFRunLoopMode  
RunLoop在同一段时间只能且必须在一种特定Mode下Run。
更换Mode时，需要停止当前Loop，然后重启新Mode。
Mode是iOS滑动顺畅的关键。

1 NSDefaultRunLoopMode   
默认状态(空闲状态)，比如点击按钮都是这个状态

2 UITrackingRunLoopMode  
滑动时的Mode。比如滑动UIScrollView时。  

3 UIInitializationRunLoopMode  
私有的，APP启动时。就是从iphone桌面点击APP的图标进入APP到第一个界面展示之前，在第一个界面显示出来后，UIInitializationRunLoopMode就被切换成了NSDefaultRunLoopMode。  

4 NSRunLoopCommonModes  

它是NSDefaultRunLoopMode和UITrackingRunLoopMode的集合。结构类似于一个数组。在这个mode下执行其实就是两个mode都能执行而已。  




