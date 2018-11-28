## # Debug 和 Release  模式

App在发布的时候,这些全部都要改成release模式。
这些都选为release,就意味着默认没有定义Debug,则上面代码中#if...#endif之间的输出NSLog不会执行.这样在发布应用程序的时候,就节省了一些硬件设备的资源.

-> 选择Product->Scheme->Edit Scheme 发布的时候进行对应的设置



## 查看是否是debug 模式

在buildsetting 中 查找 macros ，如果是debug 模式 

在Preprocessor Macros的Debug后面会有DEBUG=1





##  在宏定义中进行使用即可

可以在不同的模式下放置对应的正式和测试的服务器地址



```objective-c
#ifdef DEBUG
// 如果是debug 模式
#define NSLog(FORMAT, ...) fprintf(stderr, "[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

// 不是debug 模式 不进行打印
#define NSLog(FORMAT, ...) nil

#endif
```





