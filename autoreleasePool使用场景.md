

autoreleasePool的使用



```objective-c

在for循环创建了很多局部变量，当遍历次数过多时造成内存急剧增加，崩溃， 可以通过添加@autoreleasepool解决；

eg:

for (int i = 0; i < 5000000; i++) {
     NSObject *obj = [[NSObject alloc] init];  // 内存暴增，局部变量没有释放

}

解决方案

for (int i = 0; i < 5000000; i++) {
     @autoreleasepool {
         NSObject *obj = [[NSObject alloc] init];  // 内存减少， 运行时间差不多

     }

}

利用@autoreleasepool优化循环其实就是利用@autoreleasepool优化循环的内存占用
    
在一个for循环中，循环创建对象。这时候就需要将初始化对象放在@autoreleasepool｛｝block块中  这样可以在每次循环结束释放临时创建的对象占用的内存。
```



如果是对NSArray数组的遍历方法的话，内部封装的有autoreleasepool

- (void)enumerateObjectsUsingBlock:






#### **Autorelease Pool的实现原理**

