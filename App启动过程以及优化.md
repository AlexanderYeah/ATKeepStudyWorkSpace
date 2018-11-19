### APP启动优化

* 1 冷启动（Cold Launch）：从零开始启动APP
* 2 热启动（Warm Launch）：APP已经在内存中，在后台存活着，再次点击图标启动APP  



## Analyse:

通过添加环境变量可以打印出APP的启动时间分析（Edit scheme -> Run -> Arguments）

* 1 DYLD_PRINT_STATISTICS设置为1
* 2 如果需要更详细的信息，那就将DYLD_PRINT_STATISTICS_DETAILS设置为1

可以查看对应的输出信息

![avatar](https://github.com/AlexanderYeah/ATKeepStudyWorkSpace/blob/master/img_source/App%E5%90%AF%E5%8A%A8%E4%BC%98%E5%8C%961.png)
 

### 

## 启动的两个阶段

### 1 pre-mian 阶段

*  加载应用的可执行文件
* 加载动态链接库加载器dyld（dynamic loader）
* dyld 递归加载应用所有依赖的dylib（dynamic library 动态链接库）

### 2 main() 阶段

* dyld调用main() 
* 调用UIApplication（）
* 调用applicationWillFinishLaunching
* 调用didFinishLaunchingWithOptions

#### 我们把 `pre-main`阶段称为 `t1`，`main()`阶段一直到**首个页面加载完成**称为 `t2`

![avatar](https://github.com/AlexanderYeah/ATKeepStudyWorkSpace/blob/master/img_source/App%E5%90%AF%E5%8A%A8%E4%BC%98%E5%8C%962.png)
 

### 启动分析

### 1 加载dylib

分析每个dylib（大部分是iOS系统的），找到其Mach-O文件，打开并读取验证有效性，找到代码签名注册到内核，最后对dylib的每个segment调用mmap()。

### 2  rebase/bind 

dylib 加载完成之后，它们处于相互独立的状态，需要绑定起来。

在dylib的加载过程中，系统为了安全考虑，引入了ASLR（Address Space Layout Randomization）技术和代码签名。

由于 ASLR的存在，镜像（Image，包括可执行文件、dylib和bundle）会在随机的地址上加载，和之前指针指向的地址（preferred_address）会有一个偏差（slide），dyld需要修正这个偏差，来指向正确的地址。 

Rebase在前，Bind在后，Rebase做的是将镜像读入内存，修正镜像内部的指针，性能消耗主要在IO。 Bind做的是查询符号表，设置指向镜像外部的指针，性能消耗主要在CPU计算。



### 3 OC setup

OC的runtime需要维护一张类名与类的方法列表的全局表

dyld做了如下操作：

对所有声明过的OC类，将其注册到这个全局表中（class registration）

将category的方法插入到类的方法列表中（category registration）

检查每个selector的唯一性（selector uniquing）



所以：如果在各个 OC 类别的 ‘load’方法里做了不少事情(如在里面使用 Method swizzle),那么这是pre-main阶段最耗时的部分。dyld运行APP的初始化函数，调用每个OC类的+load方法，调用C++的构造器函数（attribute((constructor))修饰），创建非基本类型的C++静态全局变量，然后执行main函数。



## 优化思路：

一  dyld

* 1 移除不需要用到的动态库
* 2 移除不需要用到的类
* 3 合并功能类似的类和扩展
* 4 尽量避免在+load方法里执行的操作，可以推迟到+initialize方法中。
* 5 Swift尽量使用struct

二  runtime

用+initialize方法和dispatch_once取代所有的__attribute__((constructor))、C++静态构造器、ObjC的+load



三  main 

- 在不影响用户体验的前提下，尽可能将一些操作延迟，不要全部都放在finishLaunching方法中
- 按需加载





 















