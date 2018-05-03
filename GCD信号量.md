# GCD 信号量
在网络请求的开发中，经常会遇到两种情况，  

[信号量的使用--> ](https://github.com/AlexanderYeah/SKNetMultiThreadWorkSpace/blob/master/Code3/SKNetDemo/SKNetDemo/ViewController.m)

1 > 一种是我在一个界面需要同时请求多种数据，全部请求到后再一起刷新界面。  
2 > 另一种是我的请求必须满足一定顺序，比如必须先请求个人信息，然后根据个人信息请求相关内容。

这就是所谓的并发和依赖，使用GCD的一个信号量来控制。
## 原理很简单
* 1  创建一个信号量
 
> dispatch_semaphore_t sem = dispatch_semaphore_create(0);  


* 2 当最后一次请求的时候 后再发信号量,信号通知，即让信号量+1,

> dispatch_semaphore_signal(sem);  


* 3 等待完成了,直到信号量大于0时，即可操作，同时将信号量-1

> dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);