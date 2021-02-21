iOS线程同步



**1.组队列(dispatch_group_t)：**

**举一个例子：用户下载一个图片，图片很大，需要分成很多份进行下载，使用GCD应该如何实现？使用什么队列？**



使用Dispatch Group追加block到Global Group Queue，这些block如果全部执行完毕，就会执行通过dispatch_group_notify添加到主队列中的block，进行图片的合并处理。



```objective-c
 dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求1
        [self request_A];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求2
        [self request_B];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求3
         [self request_C];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(@"任务均完成，刷新界面");
    });
 
```

 

**2.阻塞任务（dispatch_barrier）：**

通过dispatch_barrier_async添加的操作会暂时阻塞当前队列，即等待前面的并发操作都完成后执行该阻塞操作，待其完成后后面的并发操作才可继续。可以将其比喻为一根霸道的独木桥，是并发队列中的一个并发障碍点，或者说中间瓶颈，临时阻塞并独占。注意dispatch_barrier_async只有在并发队列中才能起作用，在串行队列中队列本身就是独木桥，将失去其意义。

可见使用dispatch_barrier_async可以实现类似dispatch_group_t组调度的效果,同时主要的作用是避免数据竞争，高效访问数据。

 

```objective-c
/* 创建并发队列 */

dispatch_queue_t concurrentQueue=dispatch_queue_create("test.concurrent.queue",DISPATCH_QUEUE_CONCURRENT);

/* 添加两个并发操作A和B，即A和B会并发执行 */

dispatch_async(concurrentQueue,^({NSLog(@"OperationA");});

dispatch_async(concurrentQueue,^(){NSLog(@"OperationB");});

/* 添加barrier障碍操作，会等待前面的并发操作结束，并暂时阻塞后面的并发操作直到完成*/

dispatch_barrier_async(concurrentQueue,^(){NSLog(@"OperationBarrier!");});

/* 继续添加并发操作C和D，要等待barrier障碍操作结束才能开始*/

dispatch_async(concurrentQueue,^({NSLog(@"OperationC");});

dispatch_async(concurrentQueue,^(){NSLog(@"OperationD");});
 

//执行结果
               
               
2017-04-04 12:25:02.344 SingleView[12818:3694480] OperationB

2017-04-04 12:25:02.344 SingleView[12818:3694482] OperationA

2017-04-04 12:25:02.345 SingleView[12818:3694482] OperationBarrier!

2017-04-04 12:25:02.345 SingleView[12818:3694482] OperationD

2017-04-04 12:25:02.345 SingleView[12818:3694480] OperationC
 
               
```



**3.信号量机制(dispatch_semaphore)：**

**信号量机制主要是通过设置有限的资源数量来控制线程的最大并发数量以及阻塞线程实现线程同步等。**

**GCD中使用信号量需要用到三个函数：**

dispatch_semaphore_create用来创建一个semaphore信号量并设置初始信号量的值；

dispatch_semaphore_signal发送一个信号让信号量增加1（对应PV操作的V操作）；

dispatch_semaphore_wait等待信号使信号量减1（对应PV操作的P操作）；

 那么如何通过信号量来实现线程同步呢？下面介绍使用GCD信号量来实现任务间的依赖和最大并发任务数量的控制。

使用信号量实现任务2依赖于任务1，即任务2要等待任务1结束才开始执行:

方法很简单，创建信号量并初始化为0，让任务2执行前等待信号，实现对任务2的阻塞。然后在任务1完成后再发送信号，从而任务2获得信号开始执行。需要注意的是这里任务1和2都是异步提交的，如果没有信号量的阻塞，任务2是不会等待任务1的,实际上这里使用信号量实现了两个任务的同步。

 