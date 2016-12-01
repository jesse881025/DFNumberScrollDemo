//
//  DFNumberScrollHelp.m
//  DFNumberScrollDemo
//
//  Created by zhanghongwei on 30/11/16.
//  Copyright © 2016年 zhanghongwei. All rights reserved.
//

#import "DFNumberScrollHelp.h"

@implementation DFNumberScrollHelp

+ (DFNumberScrollView*)creatView:(NSInteger)style
{
    DFNumberScrollView* view = [[DFNumberScrollView alloc] init];
    view.frame = CGRectMake(0, 0, 0, 0);
    NSString *prefix = nil;
    if (style == 0) {
        prefix = @"blue_Num";
    }
    else if (style == 1) {
        prefix = @"white_Num";
    }
    else if (style == 2) {
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = [UIColor blackColor];
    }
    if (prefix) {
        view.separatorImg = [prefix stringByAppendingString:@"_seperator"];
        view.numImgs = [NSMutableArray new];
        for (NSInteger i = 0; i<10; i++) {
            NSString *numName = [NSString stringWithFormat:@"%@_%ld",prefix,(long)i];
            [view.numImgs addObject:numName];
        }
    }
    
    return view;
}


@end















