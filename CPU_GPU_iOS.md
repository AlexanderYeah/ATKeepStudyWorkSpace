# CPU 和 GPU  
## CPU 中央处理器。在iOS 设备中，工作是在软甲层面  
## GPU 图形处理器。工作是在硬件层面。
大多数动画性能优化都是关于智能利用GPU和CPU，使得它们都不会超出负荷。于是我们首先需要知道Core Animation是如何在两个处理器之间分配工作的。  

Core Animation 在iOS中处于一个核心的地位。一段动画会被分离成四个阶端

1. 布局
准备你的视图，图层的层级关系，设置图层的属性的阶段  
2. 显示 
图层的寄宿图片被绘制的片段。绘制有可能涉及你的drwaRect 和 drawLayer: inContext: 调用路径  
3. 准备
Core Animation 准备发送动画数据到渲染服务阶段。
4. 提交
最后的阶段，Core Animation 打包所有的图层和动画属性，通过IPC（内部处理通信）发到渲染服务进行显示。
 
 
![简书链接](https://www.jianshu.com/p/b03bc9a06ca8) 