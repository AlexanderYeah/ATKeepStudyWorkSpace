# Review  
## 一  OC 的反射机制
* class 反射 通过类名的字符串形式实例化对象

Class cls = NSClassFromString@(@"student");  
Student *stu = [[cls alloc]init]; 

* 将类名变为字符串 
Class cls = [Student alloc]init];
NSString *clsName = NSStringFromClass(cls);

* 通过方法的字符串形式实例化出来方法  
SEL selector = NSSelectorFromClass(@"setName");
[stu performSelector:selector withObject:nil];

* 将方法变成字符串
NSStringFromSelector(@selector*(setName:));


##  二 面向对象的特点
### 1 封装: 是将对象的数据以及方法隐藏在对象的内部，不允许外部程序直接访问对象内部的信息,而是通过该类所提供的方法来实现对内部信息的操作和访问。使用者不需要了解具体的实现细节，通过外部的接口访问。

### 封装的好处：
1. 良好的封装能够减少耦合。
2. 可以对成员进行更为精确的控制。
3. 隐藏信息实现的细节。
4. 类内部的结构可以自由修改。



### 2 继承
继承是从已有类得到继承信息创建新类的过程。提供继承信息类的方法称为父类（超类 基类）。得到继承信息的类被称为子类（派生类）。
继承应该遵循里氏替换原则：当一个子类的实例应该能够替换任何其超类的实例时，它们之间才具有 is-a 关系。  

### 3 多态
允许不同子类型的对象对同一类型的消息作出不同的相应。简单的说，就是同样的对象引用调用同样的方法却做了不同的事情。
#### 多态实现的条件  
1. 必须存在继承关系
2. 子类重写父类的方法
3. 父类声明的变量指向子类的对象。


#### 多态又分为编译时的多态和运行时的多态  

编译时的多态是方法重载(overload),也称之为前绑定。
运行时的多要是方法重写(override),也称之为后绑定。


重载（overload）：函数名相同,函数的参数列表不同(包括参数个数和参数类型)，至于返回类型可同可不同。重载既可以发生在同一个类的不同函数之间，也可发生在父类子类的继承关系之间，其中发生在父类子类之间时要注意与重写区分开。

重写（override）：发生于父类和子类之间，指的是子类不想继承使用父类的方法，通过重写同一个函数的实现实现对父类中同一个函数的覆盖，因此又叫函数覆盖。注意重写的函数必须和父类一模一样，包括函数名、参数个数和类型以及返回值，只是重写了函数的实现，这也是和重载区分开的关键。

![OC 中的重载和重写的详解](Objective-C中的重载和重写详解)

## 三 动态运行时语言
数据类型的确定有编译的时候推迟到运行时。其实涉及到两个概念，运行时和多态。运行时机制使得我们知道运行时才决定一个对象的类别，以及调用该类别的对象指定方法。
多态：不同对象以自己的方式相应相同消息的能力叫做多态。  

## 四 懒加载
在用到的时候去进行初始化，重写对象的getter方法。
优点：
1. 简化代码，增加代码的可读性
2. 对系统内存的占有率会减小
3. 每一个getter 方法负责各自的实例化处理，降低代码的耦合性。


## 五 如何访问并且修改一个类的私有属性
1. 一种是通过KVC获取  

2. 一种是通过runtime访问并修改私有属性  

```  
	// Person 类内部有两个私有属性 name 和 sex
	
	Person *p = [Person new];
	
	// 记录person类的私有属性的数量
	unsigned int count = 0;
	// IVar 是 runtime 声明的一个宏
	Ivar *members  = class_copyIvarList([Person class], &count);
	
	for (int i = 0; i < count ; i ++) {
		Ivar ivar = members[i];
		// 取得属性名并转成字符串类型
		const char *memberName = ivar_getName(ivar);
		// 打印出每一个属性的名字
		NSLog(@"%s",memberName);
		// 修改属性的名字
		Ivar name = members[0];
		object_setIvar(p, name, @"alex");
		
	}
	
	
	NSLog(@"%@",[p valueForKey:@"name"]);  
	
```



 