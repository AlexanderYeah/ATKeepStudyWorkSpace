

### KVO 的实现原理



#### 一 原理

###### 1.KVO是基于runtime机制实现的

###### 2.当某个类的属性对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的setter 方法。派生类在被重写的setter方法内实现真正的通知机制

###### 3.如果原类为Dog，那么生成的派生类名为NSKVONotifying_Dog

###### 4.每个类对象中都有一个isa指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将isa指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的setter方法

###### 5.键值观察通知依赖于NSObject  的两个方法: willChangeValueForKey: 和 didChangevlueForKey:；在一个被观察属性发生改变之前，  willChangeValueForKey:一定会被调用，这就  会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而  observeValueForKey:ofObject:change:context: 也会被调用。

#### 

#### 二 内部实现

1 在添加监听之前 通过object_getClass 获取isa 的指向 为 Dog

在添加监听之后，为NSKVONotifying_Dog



2  通过class_copyMethodList 获取一个类的方法列表，循环遍历出来。





* 一个属性发生改变之前会进行调用此方法 willChangeValueForKey

* 调用setName 修改属性的方法
* 一个属性发生改变之后进行调用此方法 didChangeValueForKey

* 之后调用 observeValueForKeyPath方法



```objective-c
@interface ViewController ()

/**我的小狗 */
@property (nonatomic,strong)Dog *litteDog;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.litteDog = [[Dog alloc]init];
    
    // 注册KVO
    // forKeyPath 你监听的值
    [self.litteDog addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:nil];
    
}

//监听回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    
    NSLog(@"oldValue--%@",oldVal);
    NSLog(@"newValue--%@",newVal);
    
}

// 触发方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.litteDog.name = [NSString stringWithFormat:@"%d-dog",arc4random() % 50];
    
}

-(void)dealloc
{
    
    // 移除监听@interface ViewController ()

/**我的小狗 */
@property (nonatomic,strong)Dog *litteDog;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.litteDog = [[Dog alloc]init];
    
    // object_getClass 获取当前isa 的 指向
    // 打印类名 Dog
    NSLog(@"%@",object_getClass(self.litteDog));
    
    // 打印方法 name  setName:
    [self printAllMethodOfClass:object_getClass(self.litteDog)];
    
    // 注册KVO
    // forKeyPath 你监听的值
    [self.litteDog addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    
    // object_getClass 获取当前isa 的 指向
    // 打印类名 NSKVONotifying_Dog
    NSLog(@"%@",object_getClass(self.litteDog));
    
    // 打印方法
    // setName:  class  dealloc  _isKVOA
    [self printAllMethodOfClass:object_getClass(self.litteDog)];
    
}

//监听回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    
    NSLog(@"oldValue--%@",oldVal);
    NSLog(@"newValue--%@",newVal);
    // 
}

// 触发方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.litteDog.name = [NSString stringWithFormat:@"%d-dog",arc4random() % 50];
    
}

-(void)dealloc
{
    
    // 移除监听的方法
    
    [self.litteDog removeObserver:self forKeyPath:@"name" context:nil];
    
}


// 打印一个类的所有方法名
- (void)printAllMethodOfClass:(Class)cls
{
    //  unsigned int 类型变量的地址用于获取 类中所有实例方法的数量
    unsigned int count;
    // 该函数的作用是获取一个类的所有实例方法
    // 方法列表
    Method *list = class_copyMethodList(cls, &count);
    // 遍历所有方法 打印
    for (int i = 0; i < count; i ++) {
        Method method = list[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        NSLog(@"%@",methodName);
    }
    
    free(list);
}


@end

```

