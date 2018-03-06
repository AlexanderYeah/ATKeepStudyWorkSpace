//
//  ViewController.m
//  kvo_demo
//
//  Created by Alexander on 2018/3/6.
//  Copyright © 2018年 alexander. All rights reserved.
//

#import "ViewController.h"
#import "Dog.h"
@interface ViewController ()
/** 实例化 */
@property (nonatomic,strong)Dog *littleDog;


@end

@implementation ViewController
static int dogNum = 2;
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.littleDog = [[Dog alloc]init];
	self.littleDog.name = @"Dog1号";
	self.littleDog.age = 5;
	
	
	// 注册KVO 方法
	
	[self.littleDog addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld context:nil];
	
	
	// 按钮触发方法
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(100, 200, 200, 40);
	[btn setTitle:@"触发回调方法" forState:UIControlStateNormal];
	[btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
	
	UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	btn2.frame = CGRectMake(100, 300, 200, 40);
	[btn2 setTitle:@"不触发回调方法" forState:UIControlStateNormal];
	[btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[btn2 addTarget:self action:@selector(btnClick2) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn2];
	
}

/**
	KVO 的回调方法
	要触发回调方法必须是在Dog类通过setter方法赋值或者是KVC
*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

	id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
	id newVal = [change objectForKey:NSKeyValueChangeNewKey];
	
	NSLog(@"oldValue--%@",oldVal);
	NSLog(@"newValue--%@",newVal);
}

/**
  按钮的点击 触发回调方法
*/
- (void)btnClick
{
	
	NSString *newName = [NSString stringWithFormat:@"Dog-%d",dogNum];
	dogNum ++;
	[self.littleDog changeNameWithSetter:newName];
	
}

- (void)btnClick2
{
	NSString *newName = [NSString stringWithFormat:@"Dog-%d",dogNum];
	dogNum ++;
	[self.littleDog changeName:newName];

}

-(void)dealloc
{
	// 移除监听
	[self.littleDog removeObserver:self forKeyPath:@"name"];
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
