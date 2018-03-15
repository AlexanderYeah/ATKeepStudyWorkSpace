# ImageView 添加圆角的方式
> imgview.layer.cornerRadius = 10;  
> imgview.clipsToBounds = YES

[资料参考](http://www.cocoachina.com/ios/20160526/16457.html)

以上的优点: 使用简单，操作方便，坏处是离屏渲染(off-screen-rendering) 需要消耗性能。加入一个项目中比较多的使用的话，不建议使用这种方式设置圆角。计算机系统中的CPU 和 GPU，显示器是协同工作的。CPU 将计算好的显示内容提交到GPU，GPU渲染完成后将渲染结果放入帧缓冲区。
简单来讲，GPU 应该做的，交给了CPU 来做，CPU又不擅长GPU 的工作，这就导致了拖慢了UI层的FPS,因此消耗了性能。

解决防范就是给UIImage 扩展一个类来剪裁圆角
