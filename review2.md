# ImageView 添加圆角的方式
> imgview.layer.cornerRadius = 10;  
> imgview.clipsToBounds = YES

[资料参考](http://www.cocoachina.com/ios/20160526/16457.html)

以上的优点: 使用简单，操作方便，坏处是离屏渲染(off-screen-rendering) 需要消耗性能。加入一个项目中比较多的使用的话，不建议使用这种方式设置圆角。计算机系统中的CPU 和 GPU，显示器是协同工作的。CPU 将计算好的显示内容提交到GPU，GPU渲染完成后将渲染结果放入帧缓冲区。
简单来讲，GPU 应该做的，交给了CPU 来做，CPU又不擅长GPU 的工作，这就导致了拖慢了UI层的FPS,因此消耗了性能。

解决防范就是给UIImage 扩展一个类来剪裁圆角



## 2 
> @property （copy） NSMutableArray *array 有什么问题  

没有指明nonatomic，因此就是atomic原子操作，会影响性能。该属性使用了同步锁，会在创建时生成一些额外的代码用于编写多线程程序，这会带来性能问题，通过声明nonatomic可以节省这些不必要的额外开销，因为就算使用了automic也不能保证绝对的线程安全，对于要绝对保证线程安全的操作，我们还需要使用更加高级的方式来处理，笔触NSSpinLock 或 @syncronized等
由于这里使用的是copy，所以得到的实际是NSArray类型，它是不可变的，若在使用中使用了增删改方法会crash；

作者：奕十八
链接：https://www.jianshu.com/p/6795714b7569
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
