# Const

# 一 const 与 宏的区别

1. 宏：预编译    const：编译阶段
2. 宏：无编译检查 即使宏写错了 知道运行的时候 才会发现。const 有编译检查，语法错误编译就能发现
3. 宏： 可以定义函数方法 const 无法定义函数方法
4. 宏：大量使用宏 导致预编译时间过长。宏其实就是代码copy



# 二 const

1. 修饰的基本变量或者指针变量
2. 被const 修饰的变量只能获取 不能修改

```	
	
	// 1
	int const a = 5;
	a = 6; //  a 是不能修改的 Cannot assign to variable 'a' with const-qualified type 'const int'
	
		
	// 2
	int b = 9;
	int *p = &b;
	// 修改b 的值
	b = 20;	// 方式1 直接修改b 的值
	*p = 30;// 方式2 获取地址修改b 的值
	
	
	// 3
	int c = 3;
	int const *q = &c;// 指针q 指向 c 的地址，*q 是不能修改的
	*q = 6; // 此时再去修改*q的值 就会报错 Read-only variable is not assignable
	NSLog(@"%d",c);
	
	int * const z; // p 只读   *p 可以修改
	int const *z1;  // z1 可修改  *z1 只读
	const int *z2;  // z2 可修改  *z2 只读
	const int * const z3; // z3 只读 *z3 只读
	int const * const z4 //z4 只读 *z4 只读
	
	
