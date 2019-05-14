//
//  ViewController.m
//  ShareDemo
//
//  Created by rpweng on 2019/5/10.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "ViewController.h"
#import "RPShareItemView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"ShareDemo";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, 200, 200, 45)];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)showShareView{
    RPShareView *view = [[RPShareView alloc] initWithFrame:self.view.bounds];
    [view showFromControlle:self];
    [view shareWithURL:@"https://open.weixin.qq.com" title:@"打造社区美好生活" description:@"顺道现邀请您参与好人好事，公益活动，新用户注册时填写你的邀请码，您将获得50积分奖励，可在APP内兑换精美礼品，还不快快参与" thumbImage:[UIImage imageNamed:@"AppIcon"]];
}

@end
