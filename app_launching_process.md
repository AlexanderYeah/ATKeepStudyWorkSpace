# App 启动过程

## 1 大体介绍
[资料参考](http://www.cocoachina.com/ios/20161114/18054.html)  

* 有 storyboard 的情况下

> 1 main 函数开始----> 2 UIApplicationMain 创建UIApplication 对象和 UIApplication的delegate对象----> 3 根据info.plist获得Main.storyboard的文件名，加载Main.storyboard----> 4 创建UIWindow----> 5 创建和设置UIWindow的rootViewController--->6 显示窗口  


* 无 storyboard 的情况下

> 1 main 函数开始 ----> 2 UIApplicationMain 创建UIApplication 对象和 UIApplication的delegate对象---->3 delegate 对象开始处理监听系统的事件application:didFinishLaunchingWithOptions: 方法 ----> 4 在 application:didFinishLaunchingWithOptions: 中创建window  ----> 5 创建和设置UIWindow的rootViewController--->6 显示窗口  

## UIApplication  
UIApplication 对象是应用程序的象征，每一个应用都有自己的UIApplication对象，并且是单例存在的。通过[UIApplication shareApplication]可以获得这个单例对象，进行一些应用级别的操作

* 设置应用程序图标右上角的红色提醒数字 applicationIconBadgeNumber
* 设置联网指示器的可见性 networkActivityIndicatorVisible
* 设置状态栏的样式
* openURL: 方法  打电话 发邮件  发短信
* 判断程序的运行状态等等

![](https://github.com/AlexanderYeah/ATKeepStudyWorkSpace/blob/master/img_source/app_start_process.png)



