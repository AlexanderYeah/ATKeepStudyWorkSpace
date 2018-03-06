//
//  Dog.m
//  kvo_demo
//
//  Created by Alexander on 2018/3/6.
//  Copyright © 2018年 alexander. All rights reserved.
//

#import "Dog.h"

@implementation Dog

/** 方式1 改变值 不触发KVO 回调方法 */
- (void)changeName:(NSString *)newName
{

	_name = newName;
}

/** 方式2 改变值 触发KVO 回调方法 */
- (void)changeNameWithSetter:(NSString *)newName
{
	self.name = newName;

}


@end
