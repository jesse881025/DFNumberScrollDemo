//
//  DFNumberScrollView.h
//  DFNumberScrollDemo
//
//  Created by zhanghongwei on 30/11/16.
//  Copyright © 2016年 zhanghongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFNumberScrollView : UIView


@property (strong, nonatomic) NSNumber *fromValue;
@property (strong, nonatomic) NSNumber *toValue;

@property (assign, nonatomic) CGSize numSize;//单个数字的大小
@property (strong, nonatomic) NSMutableArray *numImgs;//数字图片
@property (copy, nonatomic) NSString *separator;//分隔符,每三位用","分隔
@property (copy, nonatomic) NSString *separatorImg;//分隔符图片


@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;

@property (assign, nonatomic) CFTimeInterval duration;//动画之行时间
@property (assign, nonatomic) CFTimeInterval durationOffset;
@property (assign, nonatomic) NSUInteger density;
@property (assign, nonatomic) NSUInteger minLength;/**<最小展示位数,不足补零*/
@property (assign, nonatomic) BOOL isAscending;/**<是否向上滚动 Y-向上 N-向下*/

- (void)startAnimation;
- (void)stopAnimation;



@end
