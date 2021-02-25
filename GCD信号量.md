# GCD 信号量
在网络请求的开发中，经常会遇到两种情况，  

[信号量的使用--> ](https://github.com/AlexanderYeah/SKNetMultiThreadWorkSpace/blob/master/Code3/SKNetDemo/SKNetDemo/ViewController.m)

1 > 一种是我在一个界面需要同时请求多种数据，全部请求到后再一起刷新界面。  
2 > 另一种是我的请求必须满足一定顺序，比如必须先请求个人信息，然后根据个人信息请求相关内容。

这就是所谓的并发和依赖，使用GCD的一个信号量来控制。
## 原理很简单
* 1  创建一个信号量

> dispatch_semaphore_t sem = dispatch_semaphore_create(0);  


* 2 当最后一次请求的时候 后再发信号量,信号通知，即让信号量+1,

> dispatch_semaphore_signal(sem);  


* 3 等待完成了,直到信号量大于0时，即可操作，同时将信号量-1

> dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);





```objective-c
/** 网络请求 */
// GCD的信号量dispatch_semaphore_t 完成以下的操作


- (IBAction)loadDataBtnClick:(id)sender {
	/*
		http://g.hiphotos.baidu.com/image/h%3D220/sign=25515a55865494ee9822081b1df4e0e1/c2fdfc039245d68802b0694eaec27d1ed31b24ae.jpg
		
		http://h.hiphotos.baidu.com/image/pic/item/d4628535e5dde711e70b7e1dadefce1b9c16617b.jpg
		
		http://g.hiphotos.baidu.com/image/pic/item/95eef01f3a292df54e6346fbb6315c6035a873b8.jpg
	*/
	
	// 去下载图片,等待所有的图片下载完成 去进行展示
	// 因此就有了一个同步的概念
	NSArray *imgUrlArr = @[@"http://g.hiphotos.baidu.com/image/h%3D220/sign=25515a55865494ee9822081b1df4e0e1/c2fdfc039245d68802b0694eaec27d1ed31b24ae.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/d4628535e5dde711e70b7e1dadefce1b9c16617b.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/95eef01f3a292df54e6346fbb6315c6035a873b8.jpg"];
	
	// 创建一个 semaphore 基于计数器的一种多线程同步机制。
	dispatch_semaphore_t sem = dispatch_semaphore_create(0);
	//
	
	
	for (int i = 0; i < imgUrlArr.count; i ++) {
	

		// 执行任务一 操作
			NSURL *url = [NSURL URLWithString:imgUrlArr[i]];
			NSURLRequest *req = [NSURLRequest requestWithURL:url];
		
			NSURLSessionDataTask *task = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
				if (!error) {
					// 没有错误 请求成功
					UIImage *image = [UIImage imageWithData:data];
					[_succImgArr addObject:image];
					NSLog(@"download %d img success",i);
				}else{
					NSLog(@"error happend");
				}
				
				// 当最后一次回调 后再发信号量,使程序继续执行
				if (i == 2) {
					// 计数加一的操作
    				dispatch_semaphore_signal(sem);
					
					NSLog(@"%lu",(unsigned long)self.succImgArr.count);
				}
				
				
			}];
		
			[task resume];
		
		
	}
	
	// 等待完成
	dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
	
	dispatch_async(dispatch_get_main_queue(), ^{
	
		NSLog(@"end");
		_firstShowImgView.image = self.succImgArr[0];
		_secondShowImgView.image = self.succImgArr[1];
		_thirdShowImgview.image = self.succImgArr[2];
		NSLog(@"%lu",(unsigned long)self.succImgArr.count);

    });
	

	/*
	
	输出结果:
2017-12-08 10:16:00.605357+0800 SKNetDemo[32281:6366178] download 0 img success
2017-12-08 10:16:00.607327+0800 SKNetDemo[32281:6366178] download 1 img success
2017-12-08 10:16:00.608976+0800 SKNetDemo[32281:6366178] download 2 img success
2017-12-08 10:16:00.609852+0800 SKNetDemo[32281:6366178] 3
2017-12-08 10:16:00.611645+0800 SKNetDemo[32281:6366139] end
2017-12-08 10:16:00.612564+0800 SKNetDemo[32281:6366139] 3
	*/

}
```

