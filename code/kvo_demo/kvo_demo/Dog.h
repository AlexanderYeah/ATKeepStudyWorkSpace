//
//  Dog.h
//  kvo_demo
//
//  Created by Alexander on 2018/3/6.
//  Copyright © 2018年 alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject

@property (nonatomic,strong)NSString *name;

@property (nonatomic,assign)int age;


/** 方式1 改变值 不触发KVO 回调方法 */
- (void)changeName:(NSString *)newName;

/** 方式2 改变值 触发KVO 回调方法 */
- (void)changeNameWithSetter:(NSString *)newName;

@end
