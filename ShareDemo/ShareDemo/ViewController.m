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
}

@end
