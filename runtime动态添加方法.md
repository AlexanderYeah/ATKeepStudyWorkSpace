



 

核心方法是

1   +(BOOL)resolveInstanceMethod:(SEL)sel

2 class_addmethod



```objective-c
	Dog *d = [[Dog alloc]init];
	// 调用一个dog 类中没有定义的方法
	[d performSelector:@selector(eat) withObject:nil];     
```



```objective-c
#import "Dog.h"
#import <objc/runtime.h>

@implementation Dog

// 调用类未实现的类方法

//+ (BOOL)resolveClassMethod:(SEL)sel
//{
//	return YES;
//	
//}

void eat(){
	NSLog(@"野狗吃饭了");
}

// 调用类未实现的对象方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
	NSString *str = NSStringFromSelector(sel);		
	NSLog(@"%@",str);
	if (sel == @selector(eat)) {
		// 动态的添加方法
		// 第一个参数 : 添加方法的类名
		// 第二个参数 : 方法编号
		// IMP（Implementation）:方法实现 传入一个指针
		// const char *types : 类型
		class_addMethod([Dog class], sel, (IMP)eat,"");
	}
    
	[super resolveInstanceMethod:sel];
	return YES;
}

```

