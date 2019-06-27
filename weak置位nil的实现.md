### 1 weak 自动置为nil的实现

runtime 维护了一个Weak表，weak_table_t

用于存储指向某一个对象的所有Weak指针。Weak表其实是一个哈希表，

key是所指对象的地址，value是weak指针的地址的数组。

在对象回收的时候，就会在weak表中进行搜索，找到所有以这个对象地址为键值的weak对象，从而置位nil。



### 2 weak实现的原理

#### 2.1 初始化步骤

runtime 会调用objc_initWeak，初始化一个新的weak指针指向对象的地址。



#### 2.2 添加引用的步骤

objc_initWeak 函数会调用 objc_storeWeak 函数，这个函数的作用是更新指针指向，创建对应的弱引用表



#### 2.3 释放的时候

最后一步是触发调用arr_clear_deallocating 函数 ，根据对象的地址将所有weak指针地址的数组，遍历数组把其中的数据置为nil。

####  



