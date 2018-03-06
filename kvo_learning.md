# KVO 
## 一 基本了解  
### KVO : (Key - Value - Observer) 键值观察者,是观察者设计模式的一种具体实现 
### KVO触发机制:一个对象(观察者),检测另一个对象(被观察者)的某属性是否发生变化,若被监测的属性发生了更改,会触发观察者的一个方法(方法名固定,类似代理方法)  

使用步骤：

1. 注册观察者  
```
// 注册KVO 方法
options: 观察属性的新值,旧值等的一些配置(枚举值) 
	[self.littleDog addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:nil];  
 ```

2. 实现回调方法  
```  
/**
	KVO 的回调方法
	要触发回调方法必须是在Dog类通过setter方法赋值或者是KVC
*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

	id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
	id newVal = [change objectForKey:NSKeyValueChangeNewKey];
	
	NSLog(@"oldValue--%@",oldVal);
	NSLog(@"newValue--%@",newVal);
}   
```

3. 触发回调方法  
回调方法的触发是必须通过在回调的类中通过setter 方法赋值或者是通过KVC ，才会触发KVO 回调方法，这是跟KVO 实现的原理是有关系的。  
```  
/**
  按钮的点击 触发回调方法
*/
- (void)btnClick
{
	
	NSString *newName = [NSString stringWithFormat:@"Dog-%d",dogNum];
	dogNum ++;
	[self.littleDog changeNameWithSetter:newName];
	
}  
```

4. 移除观察者  
在dealloc 中移除对应的观察者  
```  
-(void)dealloc
{
	// 移除监听
	[self.littleDog removeObserver:self forKeyPath:@"name"];
}
```

一般KVO 崩溃的原因

* 被观察的对象销毁掉了(被观察的对象是一个局部变量)
* 观察者被释放掉了,但是没有移除监听(如模态推出,push,pop等)
* 注册的监听没有移除掉,又重新注册了一遍监听  


# KVO 实现的原理
### 1.KVO是基于runtime机制实现的  
### 2.当某个类的属性对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的setter 方法。派生类在被重写的setter方法内实现真正的通知机制  
### 3.如果原类为Person，那么生成的派生类名为NSKVONotifying_Person
### 4.每个类对象中都有一个isa指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将isa指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的setter方法  
### 5.键值观察通知依赖于NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey:；在一个被观察属性发生改变之前， willChangeValueForKey:一定会被调用，这就 会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而 observeValueForKey:ofObject:change:context: 也会被调用。  
![11](https://github.com/AlexanderYeah/ATKeepStudyWorkSpace/blob/master/img_source/kvo1.png)
