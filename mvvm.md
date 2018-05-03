# MVVM 详解
MVVM来自微软，是一个相当不错的架构模式。  

* Model  数据模型 
* ViewModel 主要是处理网络请求
* View 包括View 和 ViewController 两个部分  

优点:
1 低耦合 视图（View）可以独立于Model变化和修改，  
2 可重用性  把一些视图逻辑放在一个ViewModel里面，让很多view重用这段视图逻辑
3 独立开发 相互独立开发,逻辑和页面的分离
4 可测试 