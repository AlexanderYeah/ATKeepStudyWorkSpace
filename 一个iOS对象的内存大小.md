### NSObject内存大小

类的本质是结构体 无须赘述

```objective-c
struct NSObject {
Class isa;  
};
```

一个类对象的实例大小是8个字节

之所以打印出的16个字节，是因为一个NSObject 最小开辟16个字节

```objective-c
    NSObject *obj = [[NSObject alloc]init];
    // class_getInstanceSize  这是runtime 获取一个类对象的实例大小的方法
    
    // 打印结果是 8
    NSLog(@"%zd",class_getInstanceSize([NSObject class]));
    // 对象指针的大小
    //  /* Returns size of given ptr */
    // 打印结果是16
    NSLog(@"%zd",malloc_size((__bridge const void *)obj));
```





int 类型的占有4个字节，isa 类型的占有8个字节,定义一个对象，有3个int 属性，实际大小为  8 + 3 * 4 = 20 字节，则打印出的类对象大小为  24个字节，而开辟的指针内存应该是32个字节。

因为内存对齐的规则,要从４的整数倍地址开始存储, 所以是有4个byte是空的，所以打印出来是24个字节。





```objective-c
@interface StudentA : NSObject


{
    @public
    int _age1;
    int _age2;
    int _age3;
    
//    NSString * _lastname;
}


@end

    StudentA *a = [[StudentA alloc]init];    
    // 打印结果是24
    NSLog(@"%zd",class_getInstanceSize([StudentA class]));
    // 打印结果是32
    NSLog(@"%zd",malloc_size((__bridge const void *)a));    
    
    
```





