# Block 的copy 操作 


Block 其实来讲有三种类型 

* 全局块 NSConcreteGlobalBlock
* 栈块 NSConcreteStackBlock
* 堆块 NSConcreteMallocBlock


* 全局块存储在全局内存中，相当于单例
* 栈块存于栈内存中，超出其作用域则马上进行销毁
* 堆块存在于堆内存中，是带一个引用计数的对象，需要自己进行内存管理


1> Block 不访问外界变量（包括堆中和栈中的变量）
既不存在栈又不在堆中，在代码段中ARC和MRC下都是如此，此时为全局块。

2 > Block 访问外界变量

ARC 环境下：访问外界变量的 Block 默认存储在堆中（实际是放在栈区，然后ARC情况下自动又拷贝到堆区），自动释放。  




自己的理解：
至于为什么要用copy 修饰 block，说直白一点，就是为了延长block 的生命周期，我们使用的block 本身是存在于栈上的，如果不适用copy，函数调用结束的时候，block 就会被销毁。
函数调用结束，调用函数开辟的栈内存就会被回收，保存在函数栈上的block 自然而然就被销毁了，我们再使用的时候，就会空指针异常。

如果是堆中的block，也就是copy 的 block，他的生命周期是随着对象的销毁而结束的，只要对象不销毁，我们就可以调用到堆中的block。  


```#import "ViewController.h"

@interface ViewController ()
// 定义一个block
@property (nonatomic,copy)void(^myBlock)(void);

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//1  全局块 存储在代码区 NSConcreteGlobalBlock
	// 不访问外部的变量就是全局块
	void (^myBlock1)(void) = ^() {
		NSLog(@"全局块");
	};
	myBlock1();
	NSLog(@"%@",myBlock1);

	
	
	//2  存储在栈区域 访问外部变量, 但是没有进行copy,函数作用域结束
	// NSConcreteStackBlock
	int q = 15;
	void(^myBlock2)(void) = ^(){
		NSLog(@"栈块 --%d",q);
	};
	
	myBlock2();
	NSLog(@"%@",myBlock2);
	//3 堆块
	// NSConcreteMallocBlock
	int p = 25;
	void(^myBlock3)(void) = ^(){
		NSLog(@"堆块--%d",p);
	};
	
	// 进行一次copy 操作
	[myBlock3 copy];
	
	myBlock3();
	NSLog(@"%@",[myBlock3 copy]);
	
	[self test];
	// 到这一行 test 函数中所有存储在栈区的变量都会进行销毁，如果myBlock 使用
	// assign 进行修饰的话,没有把block copy到堆内存中的话，在下面的代码再进行访问的话，就会造成问野指针访问. EXC_BAD_ACCESS 错误
	
	// 所以要使 copy 属性进行修饰
	self.myBlock();
}


- (void)test
{
	int a = 10;
	[self setMyBlock:^{
	
		NSLog(@"myblock--%d",a);
	}];
	
	NSLog(@"test--%@",self.myBlock);

}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

```  


