一  扩大一个按钮的点击范围



核心就是给按钮添加一些属性

**objc_setAssociatedObject**



```objective-c
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (EnlargeEdge)

// 设置可点击范围到按钮边缘的距离
-(void)setEnLargeEdge:(CGFloat)size;

// 设置可点击范围到按钮上、右、下、左的距离
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
    
#import "UIButton+EnlargeEdge.h"

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

@implementation UIButton (EnlargeEdge)

-(void)setEnLargeEdge:(CGFloat)size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);

}

// 设置可点击范围到按钮上、右、下、左的距离
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);

}

-(CGRect)enlargedRect
{
    NSNumber *topEdge=objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge=objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge=objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge=objc_getAssociatedObject(self, &leftNameKey);
    
    if(topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x-leftEdge.floatValue,
                          self.bounds.origin.y-topEdge.floatValue,
                          self.bounds.size.width+leftEdge.floatValue+rightEdge.floatValue,
                          self.bounds.size.height+topEdge.floatValue+bottomEdge.floatValue);
    
    }else{
        return self.bounds;
    }

}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect=[self enlargedRect];
    if(CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point)?YES:NO;

}
@end
    
```



#### 二   处理异常崩溃（NSDictionary, NSMutableDictionary,  NSArray, NSMutableArray 的处理）

在开发过程中， 有时候会出现set object for key的时候 object为Nil或者Key为Nil， 又或者初始化array, dic的时候由于数据个数与指定的长度不一致造成崩溃。 此时利用runtime对异常情况进行捕捉，提前return或者抛弃多余的长度。

```objective-c
二 处理异常崩溃（NSDictionary, NSMutableDictionary, NSArray, NSM#import "NSDictionary+Safe.h"
#import <objc/runtime.h>
 
@implementation NSDictionary (Safe)
 
+ (void)load {
    Method originalMethod = class_getClassMethod(self, @selector(dictionaryWithObjects:forKeys:count:));
    Method swizzledMethod = class_getClassMethod(self, @selector(na_dictionaryWithObjects:forKeys:count:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}
 
+ (instancetype)na_dictionaryWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt {
    id nObjects[cnt];
    id nKeys[cnt];
    int i=0, j=0;
    for (; i<cnt && j<cnt; i++) {
        if (objects[i] && keys[i]) {
            nObjects[j] = objects[i];
            nKeys[j] = keys[i];
            j++;
        }
    }
    
    return [self na_dictionaryWithObjects:nObjects forKeys:nKeys count:j];
}
 
@end
 
@implementation NSMutableDictionary (Safe)
 
+ (void)load {
    Class dictCls = NSClassFromString(@"__NSDictionaryM");
    Method originalMethod = class_getInstanceMethod(dictCls, @selector(setObject:forKey:));
    Method swizzledMethod = class_getInstanceMethod(dictCls, @selector(na_setObject:forKey:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}
 
- (void)na_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject || !aKey)
        return;
    [self na_setObject:anObject forKey:aKey];
}
 
@endutableArray 的处理）

在开发过程中， 有时候会出现set object for key的时候 object为Nil或者Key为Nil， 又或者初始化array, dic的时候由于数据个数与指定的长度不一致造成崩溃。 此时利用runtime对异常情况进行捕捉，提前return或者抛弃多余的长度。
。
```

