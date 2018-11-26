## extern

extern 主要是用来引用全局变量，原理是先在本文件中进行查找，在文件中查找不到的再到其他文件中查找。

不会分配内存空间，找到已经分配好的内存空间，进行引用。



extern 和 const 进行配合使用





——>  声明文件

```objective-c

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SKConst : NSObject

// 进行引用
extern NSString *const LA_NOTIFICATION_NAME;


@end

NS_ASSUME_NONNULL_END

```



——> 实现文件

```objective-c
#import "SKConst.h"

// 登录的通知
NSString *const LA_NOTIFICATION_NAME = @"LoginAction";

@implementation SKConst


@end
```



