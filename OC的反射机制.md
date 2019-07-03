## OC 的反射机制

### 一 定义概念

普遍的概念就是类似于java的反射机制，动态机制使得OC语言更加灵活。

反射机制就是可以根据指定的类名获取类的相关信息。



### 二 作用

#### 1 根据类名获得class



```objective-c
//  选择器 和字符串之间的相互转化
FOUNDATION_EXPORT NSString *NSStringFromSelector(SEL aSelector);
FOUNDATION_EXPORT SEL NSSelectorFromString(NSString *aSelectorName);

// 类 和 字符串相互之间的转化
FOUNDATION_EXPORT NSString *NSStringFromClass(Class aClass);
FOUNDATION_EXPORT Class _Nullable NSClassFromString(NSString *aClassName);

// 协议和字符串之间相互的转化
FOUNDATION_EXPORT NSString *NSStringFromProtocol(Protocol *proto) API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT Protocol * _Nullable NSProtocolFromString(NSString *namestr) API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

```





```objective-c
    // 创建类的方法大致分为下面的三种
    Class cls1 = NSClassFromString(@"NSData");
    NSData * data = [[NSData alloc]init];
    Class cls3 = [NSData class];
```

#### 2 检查继承的关系

```objective-c
 
    NSString *str = [[NSString alloc]init];
    
    // 判断当前的类是否为此类的对象
    [str isMemberOfClass:[NSString class]];

    // 判断是否为某一个类或者子类的对象
    [str isKindOfClass:[NSString class]];
    // 判断对视是否实现了指定的协议
    [str conformsToProtocol:@protocol(NSCopying)];
    // 是否实现对应的方法
    [str respondsToSelector:@selector(printAction)];
```

