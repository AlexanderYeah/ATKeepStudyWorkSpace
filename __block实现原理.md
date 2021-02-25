## __Block 修饰符

Block 想要改变外部的变量，必须要用__Block 来修饰自动变量。



根据内存地址可以看出来，__block 所修饰的变量，将外部的变量在栈中的内存地址放到了堆中。

```objective-c
        // auto 自动变量的内存分配在栈区域 stack
        __block int meters = 1000;
        // 在block 引用之前 0x7ffeefbff4f8
        NSLog(@"在block 引用之前 %p",&meters);
        // 3 无返回值无参数
        void (^Run1)(void) = ^{
            
            meters = 2000;
            // 在block 引用之后 0x100502ac8
            NSLog(@"在block 引用之后 %p",&meters);
            NSLog(@"i have run %d meters",meters);
        } ;
        
        Run1();
```



转为C++ 代码 看出

meter 是如何改变的 

先是找到 __forwarding 结构体，然后的话再去找打结构体内部的meter 属性

> (meters->__forwarding->meters) = 2000;



````c++
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_meters_0 *meters; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_meters_0 *_meters, int flags=0) : meters(_meters->__forwarding) {
    
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

// meter 包装成一个对象，里面是含有一个isa 指针的
struct __Block_byref_meters_0 {
  void *__isa;
__Block_byref_meters_0 *__forwarding;
 int __flags;
 int __size;
 int meters;
};

//meter 是如何改变的

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_meters_0 *meters = __cself->meters; // bound by ref
    
            (meters->__forwarding->meters) = 2000;
        }


````





- 1 在ARC 环境下,Block 被引用的时候，会被Copy 一次，由栈区Copy 到堆区域

- 2 在Block 被Copy的时候,Block 内部的变量也会被copy 一份到堆上面

- 3 被__Block 修饰的变量，在被Block 引用的时候，会变成结构体也就是OC的对象，里面的————forwarding 指针由栈copy 到堆上面

- 4 栈上__block 变量结构体中，__forwarding的指针指向堆上面__block 变量结构体，堆上的__block 变量结构体中的

  __forwarding 指针指向自己

- 5 当block 从堆中移除的时候，会调用block 内部的dispose 函数，dispose函数内部会调用_Block_object_dispose函数，_Block_object_dispose函数会自动释放引用的__block变量（release)

图片

![](https://github.com/AlexanderYeah/ATKeepStudyWorkSpace/blob/master/img_source/block__forwarding.jpg)

