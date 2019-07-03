### 1 load 函数

调用时机，当类引用进项目的时候执行load函数，在main函数开始之前，与

这个类是否被用到是无关的，每个类的load函数都会自动调用一次。

* 1 父类和子类都实现load函数的时候，父类的load方法优先于子类
* 2 类中的load方法执行顺序优先于类别（Category）
* 3 当有多个类别（Category）实现load方法时候。会按照顺序执行

* 4 子类load方法 和 父类load 方法不存在覆盖的现象

#### 执行顺序：父类--> 子类---> 分类

#### 

### 2 initialize 方法

此方法不适用不调用，一旦类文件使用，则第一个调用此方法。

* 1 父类的initialize 方法会比子类的先执行

* 2 子类未实现initialize 方法，则会调用父类此方法

* 3 子类实现initialize方法，则会覆盖父类此方法

* 4 当多个分类Category，只执行最后一个分类的initialize方法


####  

#### 执行顺序：父类--> 子类

#### 



### 3 原理解读

load 是直接在内存中进行调用

initialize 是通过obj_msg_send 消息机制调用



load 方法是 在运行时时期，循环调用所有类的 +load 方法。直接使用函数内存地址的方式 `(*load_method)(cls, SEL_load);` 而不是使用发送消息 `objc_msgSend` 的方式。

具体的实现 还是要月度runtime 源码来看



