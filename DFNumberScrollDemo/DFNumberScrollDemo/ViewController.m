//
//  ViewController.m
//  DFNumberScrollDemo
//
//  Created by zhanghongwei on 30/11/16.
//  Copyright © 2016年 zhanghongwei. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "LNGTeamPKscoreView.h"
#import "DFNumberScrollHelp.h"


@interface ViewController ()

//团队PK数据
@property (nonatomic, strong) LNGTeamPKscoreView *teamPKscoreView;

//系统默认的数字
@property (nonatomic, strong) DFNumberScrollView *sysNumView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    //团队PK数据
    self.teamPKscoreView = [[LNGTeamPKscoreView alloc] init];
    [self.view addSubview:self.teamPKscoreView];
    //self.teamPKscoreView.hidden = YES;
    //团队PK数据
    __weak __typeof(&*self)weakSelf = self;
    [self.teamPKscoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@50);
        make.height.equalTo(@0);//40
    }];
    [self clickButton:nil];
    
    
    //系统的数字
    self.sysNumView = [DFNumberScrollHelp creatView:2];
    self.sysNumView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sysNumView];
    [self.sysNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@100);
        make.height.equalTo(@0);//40
        make.width.equalTo(@0);
    }];
    [self clickSysNumBtn:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSysNumBtn:(id)sender
{
    static NSInteger num1 = 0;
    num1 += (rand() % 1000);
    NSNumber *countNum1 = [NSNumber numberWithInteger:num1];
    
    [self.sysNumView setToValue:countNum1];
    [self.sysNumView startAnimation];
    
    __weak __typeof(&*self)weakSelf = self;
    [self.sysNumView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(weakSelf.sysNumView.frame.size.width));
        make.height.equalTo(@(weakSelf.sysNumView.frame.size.height));
    }];
    [UIView animateWithDuration:0.4f animations:^{
        [weakSelf.sysNumView.superview layoutIfNeeded];
    }];
    
}

- (IBAction)clickButton:(id)sender
{
    static NSInteger num1 = 0;
    num1 += (rand() % 1000);
    static NSInteger num2 = 0;
    num2 += (rand() % 1000);
    
    NSNumber *countNum1 = [NSNumber numberWithInteger:num1];
    NSNumber *countNum2 = [NSNumber numberWithInteger:num2];
    
    //加载数据
    [self.teamPKscoreView loadData:countNum1 rightScore:countNum2];
    //[self updateTeamPKscoreView];
}

//团队PK数据
- (void)updateTeamPKscoreView
{
    CGFloat height = self.teamPKscoreView.hidden?0.0f:40.f;
    [self.teamPKscoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        //make.height.equalTo(@40);
        make.height.equalTo(@(height));
    }];
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.4f animations:^{
        [weakSelf.teamPKscoreView.superview layoutIfNeeded];
    }];
}



@end




















