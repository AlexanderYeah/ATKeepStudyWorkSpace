## OC的分类

### 1 OC  分类作用



* 生命私有的方法
* 分解体积庞大的类文件
* 把Framework的私有方法公开



### 2 分类的特点

* 运行时决议
* 可以为系统添加分类



### 3 分类可以添加哪些内容

* 实例方法
* 类方法

* 协议
* 属性



分类会被编译成一个结构体

```objective-c
struct category_t {
    
    const char *name;                           分类名称
    classref_t cls;                             该分类所属的宿主类
    struct method_list_t *instanceMethods;      实例方法列表
    struct method_list_t *classMethods;         类方法列表
    struct protocol_list_t *protocols;          协议列表
    struct property_list_t *instanceProperties; 实例属性列表
    
}
```



###  4 分类的加载调用栈

去苹果的网站下载runtime 的源码 去一下，找打objc文件夹，下载一个源码，找到runtime文件夹下面的objc-runtime-new 文件打开就是的

[✈️✈️✈️](https://opensource.apple.com/tarballs/)



宿主类的方法列表是一个二维数组

假设分类有三个分类，每一个分类有三个方法，存放顺序就是这样的顺序。

也就解释了问什么分类方法覆盖的问题，方法调用的时候一旦查到第一个方法名就会返回，位置靠前的同名方法方法有优先执行的权利。

[[method_1,method_2,method_3],[method_1,method_2,method_3],[method_1,method_2,method_3]]



此句话 才是分类方法真正的添加到宿主类上面

>  rw->methods.attachLists(mlists, mcount);



```objective-c

static void remethodizeClass(Class cls)
{
    category_list *cats;
	
    bool isMeta;

    runtimeLock.assertLocked();
	// 假设为NO
    isMeta = cls->isMetaClass();

    // Re-methodizing: check for more categories
    // cats 是未拼接分类的列表
    // unattachedCategoriesForClass 在对应的类中获取是否有未拼接的分类方法 如果有的话 进行拼接整合操作
	// attachCategories 将所有的分类拼接到所属的宿主类上面
    if ((cats = unattachedCategoriesForClass(cls, false/*not realizing*/))) {
        if (PrintConnecting) {
            _objc_inform("CLASS: attaching categories to class '%s' %s", 
                         cls->nameForLogging(), isMeta ? "(meta)" : "");
        }
        
        attachCategories(cls, cats, true /*flush caches*/);        
        free(cats);
    }
}




attachCategories(Class cls, category_list *cats, bool flush_caches)
{
    if (!cats) return;
	
	
	
    if (PrintReplacedMethods) printReplacements(cls, cats);
	
	// 判断是实例方法 或者 类方法
    bool isMeta = cls->isMetaClass();

    // fixme rearrange to remove these intermediate allocations
	
    // 方法列表
    method_list_t **mlists = (method_list_t **)
        malloc(cats->count * sizeof(*mlists));
        // 属性列表
    property_list_t **proplists = (property_list_t **)
        malloc(cats->count * sizeof(*proplists));
        // 协议列表
    protocol_list_t **protolists = (protocol_list_t **)
        malloc(cats->count * sizeof(*protolists));

    // Count backwards through cats to get newest categories first
    int mcount = 0;
    int propcount = 0;
    int protocount = 0;
    // 宿主类分类的总数
    int i = cats->count;
    bool fromBundle = NO;
    while (i--) {
    // 倒叙的遍历 先访问最后编译的分类
    // 如果是两个分类有同名的方法，最后编译的分类的方法会最终生效
		
    	// 获取一个分类
        auto& entry = cats->list[i];

		// 获取该分类的方法列表
        method_list_t *mlist = entry.cat->methodsForMeta(isMeta);
        if (mlist) {
        	// 最后编译的分类最先添加到分类数组中
            mlists[mcount++] = mlist;
            fromBundle |= entry.hi->isBundle();
        }

        property_list_t *proplist = 
            entry.cat->propertiesForMeta(isMeta, entry.hi);
        if (proplist) {
            proplists[propcount++] = proplist;
        }

        protocol_list_t *protolist = entry.cat->protocols;
        if (protolist) {
            protolists[protocount++] = protolist;
        }
    }

    auto rw = cls->data();

    prepareMethodLists(cls, mlists, mcount, NO, fromBundle);
    
    // 将分类的方法 mlists 数组拼接到宿主的方法列表上面去
    rw->methods.attachLists(mlists, mcount);
    free(mlists);
    if (flush_caches  &&  mcount > 0) flushCaches(cls);

    rw->properties.attachLists(proplists, propcount);
    free(proplists);

    rw->protocols.attachLists(protolists, protocount);
    free(protolists);
}

```

 