OC作为一门面向对象的语言，自然具有面向对象的语言特性：封装、继承、多态。



它既具有静态语言的特性（如C++），又有动态语言的效率（动态绑定、动态加载等）。总体来讲，OC确实是一门不错的编程语言，

 Objective-C具有相当多的动态特性，



表现为三方面：动态类型（Dynamic typing）、动态绑定（Dynamic binding）和动态加载（Dynamic loading）。动态——必须到运行时（run time）才会做的一些事情。



1 动态类型：即运行时再决定对象的类型，这种动态特性在日常的应用中非常常见，简单来说就是id类型。事实上，由于静态类型的固定性和可预知性，从而使用的更加广泛。静态类型是强类型，而动态类型属于弱类型，运行时决定接受者。

 2 动态绑定：基于动态类型，在某个实例对象被确定后，其类型便被确定了，该对象对应的属性和响应消息也被完全确定。



表现为对象方法的调用实际上是对对象发送消息，编译时不确定这个对象执行什么方法，而在运行时由消息（方法选择器selector决定对象执行什么方法），这种消息发送的方式叫做**动态绑定**。



```objective-c
// 类的数据结构
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;
    
#if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
#endif
    
} OBJC2_UNAVAILABLE;

//  方法的定义
typedef struct objc_method *Method;
struct objc_method {
    SEL method_name                                          OBJC2_UNAVAILABLE;
    char *method_types                                       OBJC2_UNAVAILABLE;
    IMP method_imp                                           OBJC2_UNAVAILABLE;
}
```



获取传入对象所属的类。

使用传入的selector在缓存`cache`列表中查询。

如果找到了方法，则通过`Method`中的`IMP`（方法实现的地址）去调用方法。

如果缓存中不存在，则开始在`methodLists`列表中查找。

如果`methodLists`列表找不到，利用`super_class`指针去父类查找，

递归地查找父类，一直查找到`NSObject`，如果还是找不到，则触发**消息转发**机制。

 





3  动态加载：根据需求加载所需要的资源，最基本就是不同机型的适配，例如，在Retina设备上加载@2x的图片，而在老一些的普通苹设备上加载原图，让程序在运行时添加代码模块以及其他资源，用户可根据需要加载一些可执行代码和资源，而不是在启动时就加载所有组件，可执行代码可以含有和程序运行时整合的新类。

