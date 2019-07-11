## OC中对象分类



## 一  oc的对象分类主要分为3种

### 1 instance 对象：

实例对象就是通过alloc 出来的对象，一个类每一次的alloc都会产生一个新的实例对象

```objective-c
    StudentA *a = [[StudentA alloc]init];
    StudentA *b = [[StudentA alloc]init];
    
    // 打印结果如下 地址是明显不同的
    // 0x6000027c2ec0
    NSLog(@"%p",a);
    // 0x6000027c2ec0
    NSLog(@"%p",b);
```



instance 对象在其内存存储的信息包括两类：

* isa 指针  8个字节
* 成员属性  int 4 个字节





### 2  class 对象

每个类的类内存中有且只有一个类对象

存储信息如下：

* isa 指针
* superclass 指针
* 类的属性信息 （@property）

* 类的协议信息 （protocal）
* 类的成员变量信息（ivar）
* 类的对象方法 （instance method）





### 3 meta-class 元类对象

每个类的内存中有且只有一个元类对象.

元类对象 和 class 对象内存结构是一致的，内存中存储的信息主要包括

* isa 指针

* superclass 指针

* 类的类方法信息

  ```objective-c
      Class cls = [NSObject class];
      Class meta_cls = object_getClass([NSObject class]);
      
      // object_getClass 是获取一个类的元类对象
      // 两个打印地址不一样，证明元类 和 类的对象地址是不同的
      // 0x105bbeec8
      NSLog(@"%p",cls);
      // 0x105bbee78
      NSLog(@"%p",meta_cls);
  ```


## 二  isa 指针指向哪里呢？

无论是instance 对象 还是 class 对象 或者是 metaclass 对象，都有一个isa 指针，那么这个isa 指针指向什么地方呢？

#### 1 instance的 isa 指向的是  class

当我们去创建一个类的对象并且去调用对象方法的时候，此时会通过instance 的isa 找到class，从而找到class 里面的对象方法进行执行



#### 2 class 的 isa 指向meta-class

当调用类方法的时候，通过class的isa指针找到meta-class，进行调用类方法。



#### 3 meta-class 的 isa  指向基类的meta-class 对象





![](https://upload-images.jianshu.io/upload_images/2069062-bc6d0d33ac95f5ee.png?imageMogr2/auto-orient/)

三 调用轨迹

instance 的isa 指向class，class 的isa 指向 meta-class，meta-class 的isa 指向基类的meta-class

instance 找打class ，如果方法不存在的话，就会通过superclass 找到父类，再去找方法

class  找到 meta-class，方法不存在，同样也会通过superclass 找父类

