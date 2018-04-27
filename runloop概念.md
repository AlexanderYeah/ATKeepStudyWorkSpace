# 一 RunLoop 概念
运行循环，程序的运行全依赖于RunLoop，程序启动，开启一个主线程，对应的默认开启一个RunLoop，来保证程序的运行。
主要负责：
# 二 作用
* 1 使程序一直运行并接受用户输入  
* 2 决定程序在何时处理一些Event
* 3 节省CPU资源（没事的时候闲着，有事的时候处理）
* 4 调用解耦(Message Queue)




# 三 runloop 最初开启的地方 --> Main 函数
程序一旦启动就会调用mian函数 ，main函数就一句代码，执行完就会return，一旦return，程序就不在了。main函数只要退出，程序就会退出了。程序启动之后之所以没有退出，是因为UIApplicationMain 开启了一个runloop，一个消息循环，do while循环，相当于死循环，所以main函数不会return，所以保证程序在运行中。
```
int main(int argc, char * argv[]) {
	@autoreleasepool {
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
```

# 四 处理事件的来源
* 定时源  (timeSource) : 是用来定时接收一些事情的，比如说，定时检查一下UI界面有没有点击事件，有没有滚动事件，所以是time sources 是处理主线程的事情。
* 输入源 (inputSource) ：performSelector：onThread 线程通信，说明输入源处理其他线程的消息。runloop的输入源就可以解决其他线程回到主线程做事情。

输入源传递异步消息，通常来自于其他线程或者程序。定时源则传递同步消息，在特定时间或者一定的时间间隔发生。


# 五 RunLoop 与 线程之间的关系
* 每条线程都有一个与之对应的RunLoop 对象
* RunLoop 保存在一个全局的Dictionary 中，线程作为key，RunLoop 作为value
* 主线程的Runloop 已经创建好了，子线程的Runloop 需要主动创建
* RunLoop 在第一次获取时创建，在线程结束的时候进行销毁。


# 六 RunLoop 与 自动释放池

Timer和Source也是一些变量，需要占用一部分存储空间，所以要释放掉，如果不释放掉，就会一直积累，占用的内存也就越来越大，这显然不是我们想要的。
那么什么时候释放，怎么释放呢？
RunLoop内部有一个自动释放池，当RunLoop开启时，就会自动创建一个自动释放池，当RunLoop在休息之前会释放掉自动释放池的东西，然后重新创建一个新的空的自动释放池，当RunLoop被唤醒重新开始跑圈时，Timer,Source等新的事件就会放到新的自动释放池中，当RunLoop退出的时候也会被释放。
注意：只有主线程的RunLoop会默认启动。也就意味着会自动创建自动释放池，子线程需要在线程调度方法中手动添加自动释放池。





NSRunLoop 是对 CFRunLoop 的封装。
CFRunLoopMode 包含 CFRunLoopSource CFRunLoopTimer CFRunLoopObserver 

## 一 CFRunLoopTimer   

系统提供的NSTimer、CADisplayLink、performSelector等都是对CFRunLoopTimer的封装。

## 二 CFRunLoopSource   
RunLoop定义了两个版本的Source,分别是Source0和Source1。

1 Source0：处理APP内部事件、APP自己负责管理(触发)，如UIEvent、CFSocket  
2 Source1：由RunLoop和内核管理，Mach Port驱动，如CFMachPort、CFMessagePort

# 三 CFRunLoopObserverRef是观察者，能够监听RunLoop的状态改变    

* kCFRunLoopEntry // 即将进入Loop
* kCFRunLoopBeforeTimers // 即将处理Timer
* kCFRunLoopBeforeSources // 即将处理Source  
* kCFRunLoopBeforeWaiting // 即将进入休眠
* kCFRunLoopAfterWaiting // 刚从休眠中唤醒  
* kCFRunLoopExit // 即将推出Loop

## 四 CFRunLoopModeRef  
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






