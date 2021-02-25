

#### Memory 和 Disk 双重机制



SDWebImage` 的图片缓存采用的是 `Memory`(内存) 和 `Disk`(硬盘) 双重 `Cache` 机制，`

SDImageCache` 中有一个叫做 `memCache` 的属性，它是一个 `NSCache` 对象，用于实现我们对图片的 `Memory Cache`，其实就是接受系统的内存警告通知，然后清除掉自身的图片缓存。
 `Disk Cache`，也就是文件缓存，`SDWebImage` 会将图片存放到 `NSCachesDirectory` 目录中，然后为每一个缓存文件生成一个 `md5文件名, 存放到文件中。



内存缓存

```objective-c
// 它是一个 `NSCache` 对象，用于实现我们对图片的 `Memory Cache`，其实就是接受系统的内存警告通知，然后清除掉自身的图片缓存。
 
@property (nonatomic, strong, readonly, nonnull) id<SDMemoryCache> memoryCache;

// Disk Cache`，也就是文件缓存，`SDWebImage` 会将图片存放到 `NSCachesDirectory` 目录中，然后为每一个缓存文件生成一个 `md5文件名, 存放到文件中。
@property (nonatomic, strong, readonly, nonnull) id<SDDiskCache> diskCache;


```

1. `SDWebImageManager`

2. `SDWebImageCache`

3. `SDWebImageDownloader`

4. `SDWebImageManagerDownloadOperation`


```objective-c
1 缓存计算,它的单位为字节 
[[[SDWebImageManager sharedManager] imageCache] getSize];  
2 缓存图片的数量 
[[[SDWebImageManager sharedManager] imageCache] getDiskCount];  
3 缓存清理，第一种是内存缓存，第二种是硬盘缓存
[[[SDWebImageManager sharedManager] imageCache] clearMemory];  
[[[SDWebImageManager sharedManager] imageCache] clearDisk];  
 SDImageCache *imageCache  = [[SDWebImageManager sharedManager] imageCache];
//SDImageCache *imageCache = [SDImageCache sharedImageCache];
查找图片：
UIImage *cacheImage = [imageCache mageFromKey:myCacheKey];
缓存图片：
[ imageCache storeImage:myImage forKey:myCacheKey];
```



####  **整体机制如下**：



- **Memory(内存)中查找**：`SDImageCache` 类的 `queryDiskCacheForKey`方法，查询图片缓存，`queryDiskCacheForKey` 方法内部， 先会查询 `Memory Cache` ，如果查找到就直接返回，反之进入下面的硬盘查找。

- **Disk(硬盘) 中查找**：如果 `Memory Cache` 查找不到， 就会查询 `Disk Cache`，查询 `Disk Cache` 的时候有一个小插曲，就是如果 `Disk Cache` 查询成功，还会把得到的图片再次设置到 `Memory Cache` 中。 这样做可以最大化那些高频率展现图片的效率。如果找不到就进入下面的网络下载。

- **网路下载**：请求网络使用的是 `imageDownloader`属性，这个示例专门负责下载图片数据。 如果下载失败， 会把失败的图片地址写入 `failedURLs` 集合，为什么要有这个 `failedURLs` 呢， 因为 `SDWebImage`默认会有一个对上次加载失败的图片拒绝再次加载的机制。 也就是说，一张图片在本次会话加载失败了，如果再次加载就会直接拒绝，`SDWebImage` 这样做可能是为了提高性能。如果下载图片成功了，接下来就会使用 `[self.imageCache storeImage]`方法将它写入缓存 ，同时也会写入硬盘，并且调用 `completedBlock` 告诉前端显示图片。

- **Disk(硬盘)缓存清理策略**：`SDWebImage` 会在每次 `APP` 结束的时候执行清理任务。 清理缓存的规则分两步进行。 第一步先清除掉过期的缓存文件。 如果清除掉过期的缓存之后，空间还不够。 那么就继续按文件时间从早到晚排序，先清除最早的缓存文件，直到剩余空间达到要求。

 



1.`UIImageView(WebCache)`，入口封装，实现读取图片完成后的回调。
 2.`SDWebImagemanager`,对图片进行管理的中转站，记录那些图片正在读取。向下层读取`Cache`（调用`SDImageCache`），或者向网络读取对象（调用`SDWebImageDownloader`）。实现`SDImageCache`和`SDWebImageDownLoader`的回调。

3.`SDImageCache`,根据`URL`作为`key`，对图片进行存储和读取（存在内存（以`URL`作为`key`）和存在硬盘两种（以`URL`的`MD5`值作为`key`））。实现图片和内存清理工作。





###  `SDWebImage`加载图片的流程

1.入口 `setImageWithURL:placeholderImage:options:`会先把 `placeholderImage`显示，然后`SDWebImageManager`根据`URL` 开始处理图片。



2.进入`SDWebImageManager` 类中`downloadWithURL:delegate:options:userInfo:`，交给
 `SDImageCache`从缓存查找图片是否已经下载
 `queryDiskCacheForKey:delegate:userInfo:.`



3.先从内存图片缓存查找是否有图片，如果内存中已经有图片缓存，`SDImageCacheDelegate`回调 `imageCache:didFindImage:forKey:userInfo:`到
 `SDWebImageManager`。



4.`SDWebImageManagerDelegate` 回调
 `webImageManager:didFinishWithImage:` 到 `UIImageView+WebCache`,等前端展示图片。



5.如果内存缓存中没有，生成 `NSOperation`
 添加到队列，开始从硬盘查找图片是否已经缓存。



6.根据`URL`的`MD5`值`Key`在硬盘缓存目录下尝试读取图片文件。这一步是在 `NSOperation` 进行的操作，所以回主线程进行结果回调 `notifyDelegate:`。



7.如果上一操作从硬盘读取到了图片，将图片添加到内存缓存中（如果空闲内存过小， 会先清空内存缓存）。`SDImageCacheDelegate`回调 `imageCache:didFindImage:forKey:userInfo:`。进而回调展示图片。



8.如果从硬盘缓存目录读取不到图片，说明所有缓存都不存在该图片，需要下载图片， 回调 `imageCache:didNotFindImageForKey:userInfo:`。

9.共享或重新生成一个下载器`SDWebImageDownloader`开始下载图片。

10.图片下载由`NSURLSession`来做，实现相关 `delegate`
 来判断图片下载中、下载完成和下载失败。



11.`connection:didReceiveData:`中利用 `ImageIO`做了按图片下载进度加载效果。



12.`connectionDidFinishLoading:`数据下载完成后交给 `SDWebImageDecoder`做图片解码处理。

13.图片解码处理在一个 `NSOperationQueue`完成，不会拖慢主线程`UI`.如果有需要 对下载的图片进行二次处理，最好也在这里完成，效率会好很多。



14.在主线程`notifyDelegateOnMainThreadWithInfo:`
 宣告解码完成 `imageDecoder:didFinishDecodingImage:userInfo:`回调给 `SDWebImageDownloader`。



15.`imageDownloader:didFinishWithImage:`回调给 `SDWebImageManager`告知图片 下载完成。

16. 通知所有的`downloadDelegates`下载完成，回调给需要的地方展示图片。



17.将图片保存到 `SDImageCache`中，内存缓存和硬盘缓存同时保存。写文件到硬盘 也在以单独`NSOperation` 完成，避免拖慢主线程。



18.`SDImageCache`在初始化的时候会注册一些消息通知，
 在内存警告或退到后台的时 候清理内存图片缓存，应用结束的时候清理过期图片。



 