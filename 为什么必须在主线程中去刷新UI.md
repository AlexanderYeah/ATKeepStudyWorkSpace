#### 在主线程去刷新UI的原理？

* UIKit 不是线程安全的，两个线程同时设置同一个背景图片,那么很有可能因为当前图片被释放了两次而导致应用崩溃。
* 在操作UI时，比如改变了 Frame、更新了 UIView/CALayer 的层次时，或者手动调用了 UIView/CALayer 的 
  setNeedsLayout/setNeedsDisplay方法后，这个 UIView/CALayer 
  会先被标记为待处理，并被提交到一个全局的容器去。之后通过Observer监听事件调用函数再遍历所有待处理的 UIView/CAlayer 。
  以执行实际的绘制和调整，并更新 UI 界面。所以，子线程会导致出现延时提交或者无法提交，而放在主线程就不会有如此影响用户交互的情况出现。

