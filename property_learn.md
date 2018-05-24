# 属性修饰符的解读  
## 1 assign
默认类型，setter 方法直接赋值，不进行任何retain操作，不改变其引用计数。一般用来基本数据类型的处理。用户非指针变量
例如 NSInteger BOOL CGFloat Int 等基本数据类型  

## 2 readonly 和 readwrite
* readwrite 读写，可读可写，这个属性是默认的。
* readonly 只生成getter方法不会有setter方法，是只读的。
readwrite 和 readonly 控制成员变量的访问权限。

## 3 strong 和 weak
* strong 强引用，其存亡直接决定了所指向对象的存亡。一个对象如果没有强指针指向（引用计数器为0）时，对象将被销毁，释放内存），其指向一个对象，相当于该对象做了一次retain操作。
* weak 弱引用 不决定对象的存亡，即使一个对象持有无数个弱引用，只要没有强引用指向它，那么还是会被清除。

## 4 atomic 和 nonatomic
多线程访问 Stack Overflow 的回答
* atomic 是默认的，是保证线程安全的问题的。对于atomic的属性，会保证 CPU 能在别的线程来访问这个属性之前，先执行完当前流程。
速度不快，因为要保证操作整体完成。
* nonatomic 如有两个线程访问同一个属性，会出现无法预料的结果，线程不安全，更快。

如果线程 A 调了 getter，与此同时线程 B 、线程 C 都调了 setter——那最后线程 A get 到的值，3种都有可能：可能是 B、C set 之前原始的值，也可能是 B set 的值，也可能是 C set 的值。同时，最终这个属性的值，可能是 B set 的值，也有可能是 C set 的值。因此来讲，nonatomic 是不安全的。但是在我们经常使用呢，就是性能的原因。

苹果默认是atomic。iOS 用 nonatomic 比较好，而 OSX 用 atomic 比较好。如果不写的话，系统按照相对比较安全的 atomic 处理。iOS 用 nonatomic 主要是出于性能考虑，OSX 上性能不是瓶颈，所以就不用了。

## copy
适用于NSString、NSArray等不可变对象。和strong类似，不过该属性会被复制一个新的副本。很多时候使用copy是为了防止Mutable（可变类型）在我们不知道的情况下修改了属性值，而用copy可以生成一个不可变的副本防止被修改。


## 扩展  
### 1 什么情况下使用weak
