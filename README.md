# ATKeepStudyWorkSpace
Lifelong learning is a process that continues throughout one's lifetime,keep studing hard!
## 1  细说OC中的load和initialize方法  
[links](http://blog.csdn.net/u014084081/article/details/48265453)    
[demo]()

OC 作为一门面向对象的语言，有类和对象的概念。编译之后，类相关的数据结构会被保留在目标文件中，运行时得到相应的解析，  
类的信息会有加载和初始化的过程。
### load 相关的方法
* 对于一个类而言，没有load方法实现就不会调用，不会考虑对NSObject的继承。
* 一个类的load方法不用写明[super load]，父类就会收到调用，并且在子类之前。  
* Category的load也会收到调用，但顺序上在主类的load调用之后。  
* 不会直接触发initialize的调用。  
### initialize 方法相关的要点  
* 和load不同，即使子类不实现initialize方法，会把父类的实现继承过来调用一遍。注意的是在此之前，
父类的方法已经被执行过一次了，同样不需要super调用。
* initialize是”惰性调用的”，即只有当用到了相关的类时，才会调用。如果某个类一直都没有使用，则其initialize方法就一直不会运行。这也就是说，应用程序无须把每个类的initialize都执行一遍。 这就与load不同，对于load来说，应用程序必须阻塞并等待所有类的load都执行完，才能继续。
