//
//  DFNumberScrollView.m
//  DFNumberScrollDemo
//
//  Created by zhanghongwei on 30/11/16.
//  Copyright © 2016年 zhanghongwei. All rights reserved.
//

#import "DFNumberScrollView.h"


@interface DFNumberScrollView(){
    NSMutableArray *numbersText;
    NSMutableArray *fromNumbersText;
    NSMutableArray *scrollLayers;
    NSMutableArray *scrollLabels;
}

@end


@implementation DFNumberScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    
    self.separator = @",";
    self.numSize = CGSizeMake(26.f/3, 35.f/3);
    //self.numSize = CGSizeMake(18.f/3, 35.f/3);
    
    
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    
    
    self.duration = 2.0;
    self.durationOffset = 0.2;
    self.density = 5;
    self.minLength = 0;
    self.isAscending = YES;
    
    
    numbersText = [NSMutableArray new];
    fromNumbersText = [NSMutableArray new];
    scrollLayers = [NSMutableArray new];
    scrollLabels = [NSMutableArray new];
}

- (void)setToValue:(NSNumber *)toValue
{
    if (_toValue) {
        _fromValue = _toValue;
    }
    
    self->_toValue = toValue;
    
    [self prepareAnimations];
}


- (void)startAnimation {
    [self prepareAnimations];
    [self createAnimations];
}
- (void)stopAnimation {
    for(CALayer *layer in scrollLayers){
        [layer removeAnimationForKey:@"JTNumberScrollAnimatedView"];
    }
}


- (void)prepareAnimations
{
    for(CALayer *layer in scrollLayers){
        [layer removeFromSuperlayer];
    }
    
    [fromNumbersText removeAllObjects];
    [numbersText removeAllObjects];
    [scrollLayers removeAllObjects];
    [scrollLabels removeAllObjects];
    
    [self createNumbersText];
    [self createScrollLayers];
}

- (void)createNumbersText
{
    NSString *textValue = self.toValue?[self.toValue stringValue]:@"0";
    NSString *fromeValue = self.fromValue?[self.fromValue stringValue]:@"0";
    NSInteger fromeLen = fromeValue.length;
    NSInteger toLen = textValue.length;
    for (NSInteger i=0; i<toLen-fromeLen; i++) {
        fromeValue = [@"0" stringByAppendingString:fromeValue];
    }
    
    for(NSInteger i = 0; i < (NSInteger)self.minLength - (NSInteger)[textValue length]; ++i){
        [numbersText addObject:@"0"];
        [fromNumbersText addObject:@"0"];
    }
    
    NSInteger count = 0;
    for(NSInteger i = [textValue length]-1; i >= 0; i--){
        if (count > 0 && count%3==0) {
            [numbersText insertObject:self.separator atIndex:0];
            [fromNumbersText insertObject:self.separator atIndex:0];
        }
        count++;
        
        [numbersText insertObject:[textValue substringWithRange:NSMakeRange(i, 1)] atIndex:0];
        [fromNumbersText insertObject:[fromeValue substringWithRange:NSMakeRange(i, 1)] atIndex:0];
    }
}

- (void)createScrollLayers
{
    CGFloat width = self.numSize.width;
    CGFloat height = self.numSize.height;
    
    CGFloat startX = 0;
    for(NSUInteger i = 0; i < numbersText.count; ++i){
        //是否是图片数字
        UIImage *image = [self textToImage:numbersText[i]];
        CGFloat widthTmp = image?image.size.width/3:width;
        CAScrollLayer *layer = [CAScrollLayer layer];
        layer.frame = CGRectMake(startX, 0, widthTmp, height);
        [scrollLayers addObject:layer];
        [self.layer addSublayer:layer];
        //依次 移动位置
        startX += widthTmp;
    }
    //更新当前view的大小
    CGRect frame = self.frame;
    frame.size.width = startX;
    frame.size.height = height;
    self.frame = frame;
    
    
    //从左到右，从第一个不一样的数字开始往后有动画
    BOOL isAnimation = NO;
    for(NSUInteger i = 0; i < numbersText.count; ++i){
        CAScrollLayer *layer = scrollLayers[i];
        NSString *numberText = numbersText[i];
        NSString *fromText = fromNumbersText[i];
        if (![fromText isEqual:numberText] && !isAnimation) {
            isAnimation = YES;
        }
        [self createContentForLayer:layer fromNumberText:fromText toNumberText:numberText isAnimation:isAnimation];
    }
}

- (void)createContentForLayer:(CAScrollLayer *)scrollLayer fromNumberText:(NSString *)fromNumberText toNumberText:(NSString *)toNumberText isAnimation:(BOOL)isAnimation
{
    NSInteger fromNumber = [fromNumberText integerValue];
    NSInteger toNumber = [toNumberText integerValue];
    NSMutableArray *textForScroll = [NSMutableArray new];
    
    if (![self.separator isEqualToString:toNumberText] && isAnimation) {
        NSInteger density = 1;
        if (fromNumber < toNumber) {
            density = toNumber-fromNumber+1;
        }
        else {
            density = 10-fromNumber;
            density += toNumber+1;
        }
        
        //第一个和最后一个是一样的，动画需从第二个开始
        [textForScroll addObject:toNumberText];
        for(NSUInteger i = 0; i < density ; ++i){
            [textForScroll addObject:[NSString stringWithFormat:@"%ld", (long)(fromNumber+i)%10]];
        }
    }
    else {
        [textForScroll addObject:toNumberText];
        [textForScroll addObject:toNumberText];
    }
    
    
    if(!self.isAscending){
        textForScroll = [[[textForScroll reverseObjectEnumerator] allObjects] mutableCopy];
    }
    
    CGFloat height = 0;
    for(NSString *text in textForScroll){
        UILabel * textLabel = [self createLabel:text];
        textLabel.frame = CGRectMake(0, height, CGRectGetWidth(scrollLayer.frame), CGRectGetHeight(scrollLayer.frame));
        [scrollLayer addSublayer:textLabel.layer];
        [scrollLabels addObject:textLabel];
        height = CGRectGetMaxY(textLabel.frame);
    }
}

- (UILabel *)createLabel:(NSString *)text
{
    UILabel *view = [UILabel new];
    
    view.textColor = self.textColor;
    view.font = self.font;
    view.textAlignment = NSTextAlignmentCenter;
    
    
    UIImage *image = [self textToImage:text];
    if (image) {
        view.attributedText = [self attributeStringWithImage:image offsetX:0 offsetY:0];
    }
    else {
        view.text = text;
    }
    
    return view;
}
//文字转图片
- (UIImage*)textToImage:(NSString*)text
{
    UIImage *image = nil;
    if ([text isEqualToString:self.separator]) {
        image = [UIImage imageNamed:self.separatorImg];
    }
    else {
        NSString *numName = nil;
        if (text.integerValue<self.numImgs.count) {
            numName = self.numImgs[text.integerValue];
        }
        image = [UIImage imageNamed:numName];
    }
    return image;
}

- (void)createAnimations
{
    
#if 1
    //单个数字执行的最小时间
    CFTimeInterval numDuration = self.duration/10.f;
    //所有列中，其中滚动的数字的最大个数
    NSInteger maxCount = 0;
    for (CALayer *scrollLayer in scrollLayers) {
        if (scrollLayer.sublayers.count>maxCount) {
            maxCount = scrollLayer.sublayers.count;
        }
    }
    //第一个和最后一个是一样的，动画需从第二个开始,数量要减1
    if (maxCount>1) {
        maxCount -= 1;
    }
    //滚动的最长时间
    CFTimeInterval maxDuration = maxCount*numDuration;
    CFTimeInterval duration = maxDuration - ([scrollLayers count]*numDuration);
    if (duration<0) {
        duration = numDuration;
    }
    CFTimeInterval offset = 0;
    for(CALayer *scrollLayer in scrollLayers){
        
        //第一个和最后一个是一样的，动画需从第二个开始
        if (scrollLayer.sublayers.count == 2) {
            continue;//不需要动画
        }
        
        CGFloat maxY = [[scrollLayer.sublayers lastObject] frame].origin.y;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
        animation.duration = duration + offset;
        //animation.duration = self.duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        if(self.isAscending){
            //第一个和最后一个是一样的，动画需从第二个开始
            animation.fromValue = @(-[[scrollLayer.sublayers firstObject] frame].size.height);
            animation.toValue = [NSNumber numberWithFloat:-maxY];
        }
        else{
            animation.fromValue = [NSNumber numberWithFloat:-maxY];
            animation.toValue = @0;
        }
        
        [scrollLayer addAnimation:animation forKey:@"JTNumberScrollAnimatedView"];
        
        offset += numDuration;
    }
    
    
#else
    
    CFTimeInterval duration = self.duration - ([numbersText count] * self.durationOffset);
    CFTimeInterval offset = 0;
    
    for(CALayer *scrollLayer in scrollLayers){
        CGFloat maxY = [[scrollLayer.sublayers lastObject] frame].origin.y;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
        animation.duration = duration + offset;
        //animation.duration = self.duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        if(self.isAscending){
            //第一个和最后一个是一样的，动画需从第二个开始
            animation.fromValue = @(-[[scrollLayer.sublayers firstObject] frame].size.height);
            animation.toValue = [NSNumber numberWithFloat:-maxY];
        }
        else{
            animation.fromValue = [NSNumber numberWithFloat:-maxY];
            animation.toValue = @0;
        }
        
        [scrollLayer addAnimation:animation forKey:@"JTNumberScrollAnimatedView"];
        
        offset += self.durationOffset;
    }
#endif
    
}

//图片转文字
- (NSMutableAttributedString *)attributeStringWithImage:(UIImage *)image offsetX:(NSInteger)offsetX offsetY:(NSInteger)offsetY{
    
    if (!image) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSTextAttachment * icon = [[NSTextAttachment alloc] init];
    icon.image = image;
    icon.bounds = CGRectMake (offsetX,offsetY,self.numSize.width,self.numSize.height);
    NSMutableAttributedString * newMsg = [[NSMutableAttributedString alloc] initWithAttributedString:[NSMutableAttributedString attributedStringWithAttachment:icon]];
    
    return newMsg;
}

@end































