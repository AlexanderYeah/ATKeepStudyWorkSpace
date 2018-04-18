# App 优化那些事 
[参考资料1](https://www.jianshu.com/p/5cf9ac335aec)

[参考资料2]()

## 1 instruments  
在iOS上进行性能分析的时候，首先考虑借助instruments这个利器分析出问题出在哪，Leaks:检查内存,看是否有内存泄露，Zombies:检查是否访问了僵尸对象,但是这个工具只能从上往下检查,不智能，Time Profiler:性能分析等等 

## 2 不要阻塞主线程  
在iOS里关于UIKit的操作都是放在主线程，因此如果主线程被阻塞住了，你的UI可能无法及时响应事件，给人一种卡顿的感觉。大多数阻塞主线程的情况是在主线程做IO操作，比如文件的读写，包含数据库、图片、json文本或者log日志等，尽量将这些操作放放到子线程(如果数据库有一次有较多的操作，记得采用事务来处理，性能相差还是挺大的)，或者在后台建立对应的dispatch queue来做这些操作，

## 3 Cache  缓存一切可以缓存的，这个在开发的时候，往往是性能优化最多的方向

一般为了提升用户体验，都会在应用中使用缓存，比如对于图片资源可以使用SDWebImage这个开源库，图片加载的时候先去本地找，
SDWebImage 查找和缓存图片时以URL作为key。(先查找内存，如果内存不存在该图片，再查找硬盘；查找硬盘时，以URL的MD5值作为key).  


## 4 减少程序启动过程中的任务
当用户点击app的图标之后，程序应该尽可能快的进入到主页面，尽可能减少用户的等待时间,不要在此过程中做耗时操作。

## 5 懒加载视图 
不要在cell里面嵌套太多的view，这会很影响滑动的流畅感，而且更多的view也需要花费更多的CPU跟内存。假如由于view太多而导致了滑动不流畅，那就不要在一次就把所有的view都创建出来，把部分view放到需要显示cell的时候再去创建。  


# tableview 的优化步骤 
### 1 reuse 重用标识符   

> static NSString *reuseID = “reuseCellID”;

### 2 opaque  cornerRadius shadow 等进行优化  

> UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

### 3 定义一种(尽量少)类型的Cell
只定义一种Cell，那该如何显示不同类型的内容呢？答案就是，把所有不同类型的view都定义好，放在cell里面，通过hidden显示、隐藏，来显示不同类型的内容。毕竟，在用户快速滑动中，只是单纯的显示、隐藏subview比实时创建要快得多。  

### 4 提前计算并缓存Cell的高度

### 5  滑动时，按需加载
但Cell本来就是用来显示数据的，不说100%带有图片，也差不多，这个时候就要考虑，下滑的过程中可能会有点卡顿，尤其网络不好的时候，异步加载图片是个程序员都会想到，但是如果给每个循环对象都加上异步加载，开启的线程太多，一样会卡顿，App 最多也就开到一般3-5条线程。


思想就是识别UITableView禁止或者减速滑动结束的时候，进行异步加载图片，快滑动过程中，只加载目标范围内的Cell，这样按需加载，极大的提高流畅度。而SDWebImage可以实现异步加载，与这条性能配合就完美了，尤其是大量图片展示的时候。而且也不用担心图片缓存会造成内存警告的问题。

```
//获取可见部分的Cell
NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
        //获取的dataSource里面的对象，并且判断加载完成的不需要再次异步加载
            
        }

```// tableView 停止滑动的时候异步加载图片
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

         if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
               //开始异步加载图片
              
            }            
```

### 6 避免大量的图片缩放、颜色渐变等，尽量显示“大小刚好合适的图片资源”
比如说你需要300 * 600 的照片，直接将宽高拼接到参数中请求后台获取对应的尺寸的图片就行。交给后台处理。

### 7 渲染方面的优化 
* 减少subviews的个数和层级,子控件的层级越深，渲染到屏幕上所需要的计算量就越大.
* 给Cell中View加阴影会引起性能问题，如下面代码会导致滚动时有明显的卡顿

```view.layer.shadowColor = color.CGColor;
view.layer.shadowOffset = offset;
view.layer.shadowOpacity = 1;
view.layer.shadowRadius = radius;
```


  