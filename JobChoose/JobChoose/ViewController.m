//
//  ViewController.m
//  JobChoose
//
//  Created by ZJH on 2018/12/14.
//  Copyright © 2018年 ZJH. All rights reserved.
//

#import "ViewController.h"
#import "JobChoseVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitle:@"职位选择" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickBtn{
    [self.navigationController pushViewController:[JobChoseVC new
                                                   ] animated:YES];
}


@end
