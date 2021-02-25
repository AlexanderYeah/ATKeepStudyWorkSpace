#### 一  定义

将函数以及执行上下文封装起来的对象

clang -rewrite-objc SKBlock.m

重点就是对象，函数和其执行上下文



Block的调用就是函数的调用



#### 二 截获变量

1对于基本数据类型的局部变量截获其值

2对于对象类型的局部变量连同所有权修饰符一起截获

3 以指针形式截获局部静态变量

不截获全局变量，静态全局变量



```objective-c
- (void)method
{	
	int a = 2;
	int (^Block)(int) = ^int(int num){
		
		return num * a;
	};
	a = 5;
    // 此处the result is -- 4
    // 因为a 是基本数据类型的局部变量，在定义的时候，就已经以值的方式传递到block内部，后面再去修改的话，是无法去截获的
	NSLog(@"the result is -- %d",Block(2));
	
}


- (void)method
{
	 
	static int a = 2;
	int (^Block)(int) = ^int(int num){
		
		return num * a;
	};
	a = 5;
    // the result is -- 10
    // 静态局部变量是截获的指针，而不是其值，所以后面修改话，通过指针找的值也是发生了改变
	NSLog(@"the result is -- %d",Block(2));
	
}


```





#### 三 __Block修饰符



一般情况下，在需要对被截获变量需要赋值的时候

对静态局部变量，全局变量，静态全局变量操作的时候，不需要__Block修饰符



__block 修饰的变量最终变成了对象



__block int a ==>  变成了一个结构体，内部是有一个isa指针，然后又有一个指向同类型的指针



赋值并不代表使用，这是关键点

```objective-c
	NSMutableArray *array = [NSMutableArray array];
	
	int (^Block)(int) = ^int(int num){
        // 这里就是使用了截获变量，并没有对其进行赋值
		[array addObject:@"123"];		
	};

	

	NSMutableArray *array = nil;	
	int (^Block)(int) = ^int(int num){
        // 这是一个赋值的操作，这时候确实要使用__block修饰符
		array = [NSMutableArray array];		 
	};


// 用__block 修饰


- (void)method
{
	__block int a = 2;
	int (^Block)(int) = ^int(int num){
		return num * a;
	};
	a = 5;
    //  the result is -- 10
	NSLog(@"the result is -- %d",Block(2));			
}



```



__forwarding 是指向自己的，为什么需要这个指针呢？



#### 四 Block的copy操作



对栈上的block copy是在堆上产生了block

对数据块上的Block copy的话，是什么也不做

对堆上的Block进行copy的话，是增加引用计数



栈上的block 以及 其变量 作用域结束之后，随之就会进行销毁操作。

在对栈上的Block和__Block变量进行copy操作的时候，此时栈上的forwarding指针指向的是堆上的--block变量，而堆上的forwarding指针指向的也是堆上的自身





#### 五 Block循环引用



