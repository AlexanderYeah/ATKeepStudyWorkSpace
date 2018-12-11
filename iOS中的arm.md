###  ARM 

简介：ARM处理器是英国Acorn有限公司设计的低功耗成本的第一款[RISC](https://baike.baidu.com/item/RISC/62696)微处理器。全称为Advanced RISC Machine。[百度介绍](https://baike.baidu.com/item/ARM/7518299?fr=aladdin)

iOS设备中的处理器都是基于ARM架构的。

|  arm   |               设备               | 真机 |
| :----: | :------------------------------: | :--: |
|  i386  | （iphone5,iphone5s以下的模拟器） |  ×   |
| x86_64 |      (iphone6以上的模拟器)       |  ×   |
| armv7  |       iphone4（真机32位）        |  √   |
| armv7s |   ipnone5,iphone5s（真机32位）   |  √   |
| arm64  |   (iphone6,iphone6p以上的真机)   |  √   |



 模拟器不会执行ARM代码，因为用模拟器的时候编译的是x86的代码，是用于在mac上本地执行的。

* 在xcode 工程中 路径

  >  project -> target -> Build settings -> Vaild Architectures 

* 指定工程被编译成可支持哪些指令集类型，而支持的指令集越多，就会编译出包含多个指令集代码的数据包，对应生成二进制包就越大，也就是ipa包会变大



* #### Build Active Architecture Only

指定是否只对当前连接设备所支持的指令集编译
当其值设置为YES，这个属性设置为yes，是为了debug的时候编译速度更快，它只编译当前的architecture版本，而设置为no时，会编译所有的版本。 所以，一般debug的时候可以选择设置为yes，release的时候要改为no，以适应不同设备。这个是xcode 已经设置好的。



这就是arm

