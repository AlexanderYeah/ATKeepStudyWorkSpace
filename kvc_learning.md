# KVC 
### Key Value Coding 间接访问其属性方法或者成员变量的机制，可以通过字符串来访问对应的属性方法或者成员变量。

## 基础操作
直接将属性当做key 设置对应的value，即可对对象的属性进行赋值
`
	Person *p = [Person new];
	
	// 直接将属性当做Key 设置对应的value
	[p setValue:@24 forKey:@"age"];

`  

## KeyPath 
除了对当前对象的属性进行赋值外， 还可以对其更深层次的对象进行赋值。
for example ，当前类中有Person 对象，person对象有Dog 的对象，Dog 有name 的属性. 通过KeyPath 进行赋值

> 	[p setValue:@"Good Dog" forKeyPath:@"dog.name"];  

## 集合运算符
KVC 提供的valueForKeyPath:方法非常强大，可以通过该方法对集合对象进行"深入的"操作，在其KeyPath 中嵌套集合运算符。
1. 集合操作符:处理集合包含的对象,根据操作符的不同返回不同的类型，返回值以NSNumber为主。
2. 数组操作符:根据操作符的条件，将符合条件的对象包含在数组中进行返回。
3. 嵌套操作符:处理集合对象中嵌套其他集合对象的情况，返回结果也是一个对象。



