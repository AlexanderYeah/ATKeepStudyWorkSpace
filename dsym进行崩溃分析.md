### What is dSYM ？

------

xCode 的每一次编译都会生成一个dsym文件，在其内部存储了16进制函数地址的映射。

在App实际执行的二进制文件中，是通过地址来调用方法，所以在App Crash 的时候，第三方工具会抓到函数崩溃调用栈。

通过对应的dsym 文件就可以找到对应的崩溃地址。

具体怎么使用，看集成哪家的SDK，去官方文档看怎么查看崩溃信息。



#### How to find dSYM ?

------

1 路径 

window ——> organizer--->Archives — 右键showinfinder---> 显示包内容--> 找到对应的dSYM 文件夹 找到对应的dsym 文件





### 用dSYM分析工具定位crash

------

[已经在我的仓库躺好的工具，自己进行编译，崩溃的地址放进去找到即可](https://github.com/AlexanderYeah/CrashAnalyseTool)





### 用命令行进行分析定位Crash

[csdn的博客](https://blog.csdn.net/hello_hwc/article/details/50036323)













