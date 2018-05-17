# 主线程同步死锁

```	
NSLog(@"--1");
	dispatch_sync(dispatch_get_main_queue(), ^{
		NSLog(@"--2");
	});
	NSLog(@"--3"); 
	
```

 To be clear  主队列是串行队列
队列决定了任务的执行方式，串行队列按照FIFO的方式进行执行。
同步或者异步决定了是否具有开启新的线程的能力去执行任务。

上面的代码解释来讲：

* 主队列中任务串行执行, Log1 第一个任务，Log3最后一个任务，中间是	dispatch_sync 同步,等待Block 中执行完毕之后，执行Log3,

* dispatch_sync 向 主队列中添加一个Log2，主队列中已经存在Log1，Log3，Log2 排在最后面。任务进行串行执行，Log3 的执行，是要等 dispatch_sync 函数返回才执行Log3

 
* 而 dispatch_sync 函数返回 必须要执行Log2,但是在主队列中,Log3是在 Log2 之前的，所以Log2 是要等 Log3 完成之后，才执行Log2，造成死锁，永远等待，无限等待。程序崩溃。
	