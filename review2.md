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

##3 CoreFoundation 框架 
在iOS 开发过程中，绝大多数使用UIKit 和 Foundation 框架可以实现大部分的开发，有时候需要使用底层框架，底层框架通常以Core 开头，比如Core Text，Core Graphics 都是以Core Foundation 为基础的C语言API.

## 3  pod install 和 pod update 的区别

* install 并不是第一次创建 podfile 时运行一次，后面就不再使用了。install 命令不仅在初始时使用，在新增或删除 repo 时也需要运行。每次添加或删除 repo 后应该执行 install 命令，这样其它的 repo 不会更新。

* update 仅仅在只需更新某一个 repo 或所有时才使用。每次执行 install 时，会将每个 repo 的版本信息写入到 podfile.lock，已存在于 podfile.lock 的 repo 不会被更新只会下载指定版本，不在 podfile.lock 中的 repo 将会搜索与 podfile 里面对应 repo 匹配的版本。即使某个 repo 指定了版本，如 pod 'A', '1.0.0'，最好也是不要使用 update，因为 repo A 可能有依赖，如果此时使用 update 会更新其依赖。
pod update不会去Podfile.lock查看指定的AFNetworking版本,直接更新到最新版本
