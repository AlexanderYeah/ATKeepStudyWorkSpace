

1 tableview的重用机制



visiableCells内保存当前显示的cells，reusableTableCells保存可重 用的cells



```objective-c
@property (nonatomic, readonly) NSArray<__kindof UITableViewCell *> *visibleCells;
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleRows;
```



比如：有100条数据，iPhone一屏最多显示10个cell。程序最开始显示TableView的情况是：

**1、**

用[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]创建10次cell，并给cell指定同样的重用标识(当然，可以为不同显示类型的 cell指定不同的标识)。并且10个cell全部都加入到visiableCells数组，reusableTableCells为空。



##### 2

 向下拖动tableView，当cell1完全移出屏幕，并且cell11(它也是alloc出来的，原因同上)完全显示出来的时候。cell11加入到 visiableCells，cell1移出visiableCells，cell1加入到reusableTableCells。

 

##### 3

接着向下拖动tableView，因为reusableTableCells中已经有值，所以，当需要显示新的 cell，cellForRowAtIndexPath再次被调用的时候，tableView dequeueReusableCellWithIdentifier:CellIdentifier，返回cell1。cell1加入到 visiableCells，cell1移出reusableTableCells；cell2移出visiableCells，cell2加入到 reusableTableCells。之后再需要显示的Cell就可以正常重用了。

 

使用过程中，我注意到，并不是只有拖动超出屏幕的时候才会更新reusableTableCells表，还有：