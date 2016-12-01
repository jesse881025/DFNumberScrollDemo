//
//  LNGTeamPKscoreView.m
//  DFNumberScrollDemo
//
//  Created by zhanghongwei on 1/12/16.
//  Copyright © 2016年 zhanghongwei. All rights reserved.
//

#import "LNGTeamPKscoreView.h"
#import "Masonry.h"

#import "DFNumberScrollHelp.h"


@interface LNGTeamPKscoreView()

//背景
@property (nonatomic, strong) UIView *bgView;
//白队
@property (nonatomic, strong) UIImageView *leftTeamFlag;
@property (nonatomic, strong) UIView *leftScoreBaseView;
@property (nonatomic, strong) DFNumberScrollView *leftScoreView;
//分格线
@property (nonatomic, strong) UIImageView *middleLineImg;
//蓝队
@property (nonatomic, strong) UIImageView *rightTeamFlag;
@property (nonatomic, strong) UIView *rightScoreBaseView;
@property (nonatomic, strong) DFNumberScrollView *rightScoreView;

@end


@implementation LNGTeamPKscoreView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self loadConstraints];
    }
    return self;
}

- (void)createView
{
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor colorWithRed:44.f/255.f green:39.f/255.f blue:39.f/255.f alpha:0.8];
    [self addSubview:self.bgView];
    
    //白队
    self.leftTeamFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgPK_leftTeam"]];
    [self addSubview:self.leftTeamFlag];
    
    self.leftScoreBaseView = [[UIView alloc] init];
    [self addSubview:self.leftScoreBaseView];
    
    //分格线
    self.middleLineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgPK_middleLine"]];
    [self addSubview:self.middleLineImg];
    
    
    //蓝队
    self.rightTeamFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgPK_rightTeam"]];
    [self addSubview:self.rightTeamFlag];
    
    self.rightScoreBaseView = [[UIView alloc] init];
    [self addSubview:self.rightScoreBaseView];
    
    
    self.leftScoreView = [DFNumberScrollHelp creatView:1];
    [self.leftScoreBaseView addSubview:self.leftScoreView];
    
    self.rightScoreView = [DFNumberScrollHelp creatView:0];
    [self.rightScoreBaseView addSubview:self.rightScoreView];
    
}

- (void)loadConstraints
{
    CGFloat bgHeight = 23.f;
    __weak __typeof(self)weakSelf = self;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.equalTo(@(bgHeight));
        make.left.equalTo(weakSelf.leftTeamFlag);
        make.right.equalTo(weakSelf.rightTeamFlag);
    }];
    self.bgView.layer.cornerRadius = bgHeight/2.f;
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView);
        make.right.equalTo(weakSelf.bgView);
        //高度在外面设置了，此处无需在设置。
        //make.height.equalTo(@(bgHeight+17));
    }];
    
    [self.leftTeamFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        //make.right.equalTo(weakSelf.leftScoreBaseView.mas_left);
    }];
    [self.leftScoreBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf).with.offset(1);
        make.left.equalTo(weakSelf.leftTeamFlag.mas_right);
        make.width.equalTo(@5);
        make.height.equalTo(@15);
    }];
    [self.middleLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.leftScoreBaseView.mas_right);
    }];
    [self.rightScoreBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf).with.offset(1);
        make.left.equalTo(weakSelf.middleLineImg.mas_right);
        make.width.equalTo(@5);
        make.height.equalTo(@15);
    }];
    [self.rightTeamFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.rightScoreBaseView.mas_right);
    }];
    
}

#pragma mark - 加载数据
- (void)loadData:(NSNumber*)leftScore rightScore:(NSNumber*)rightScore
{
#if 0
    //for test
    leftScore = [NSNumber numberWithInteger:547897818];
    rightScore = [NSNumber numberWithInteger:238589798];
#else
    if (!leftScore) {
        leftScore = [NSNumber numberWithInteger:0];
    }
    if (!rightScore) {
        rightScore = [NSNumber numberWithInteger:0];
    }
#endif
    
    __weak __typeof(&*self)weakSelf = self;
    [self.leftScoreView setToValue:leftScore];
    [self.leftScoreView startAnimation];
    [self.leftScoreBaseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(weakSelf.leftScoreView.frame.size.width));
        make.height.equalTo(@(weakSelf.leftScoreView.frame.size.height));
    }];
    
    
    [self.rightScoreView setToValue:rightScore];
    [self.rightScoreView startAnimation];
    [self.rightScoreBaseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(weakSelf.rightScoreView.frame.size.width));
        make.height.equalTo(@(weakSelf.rightScoreView.frame.size.height));
    }];
}

@end









