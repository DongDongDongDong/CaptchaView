//
//  CaptchaView.m
//  CaptchaView
//
//  Created by andylau on 2016/10/18.
//  Copyright © 2016年 andylau. All rights reserved.
//


#define kRandomColor  [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0];
#define kLineCount 4
#define kLineWidth 1.0
#define kCharCount 4
#define kFontSize [UIFont systemFontOfSize:arc4random() % 5 + 15]

#import "CaptchaView.h"

@implementation CaptchaView
@synthesize changeString,changeArray;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = kRandomColor;
        
        [self changeCaptcha];
    }
    
    return self;
}
#pragma mark 更换验证码,得到更换的验证码的字符串


-(void)changeCaptcha
{
    self.changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    NSMutableString *getStr = [[NSMutableString alloc] initWithCapacity:kCharCount];
    self.changeString = [[NSMutableString alloc] initWithCapacity:kCharCount];
    
    //随机从数组中选取需要个数的字符，然后拼接为一个字符串
    for(int i = 0; i < kCharCount; i++)
    {
        NSInteger index = arc4random() % ([self.changeArray count]);
        getStr = [self.changeArray objectAtIndex:index];
        
        self.changeString = (NSMutableString *)[self.changeString stringByAppendingString:getStr];
    }
    
    if (self.changeCaptchaBlock) {
        self.changeCaptchaBlock();
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self changeCaptcha];
    //setNeedsDisplay调用drawRect方法来实现view的绘制
    [self setNeedsDisplay];
}

#pragma mark 绘制界面（1.UIView初始化后自动调用； 2.调用setNeedsDisplay方法时会自动调用）
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.backgroundColor = kRandomColor;
    
    //获得要显示验证码字符串，根据长度，计算每个字符显示的大概位置
    // width height为每个字符可变的最大宽高
    NSString *text = [NSString stringWithFormat:@"%@",self.changeString];
    CGSize cSize = [@"S" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    int width = rect.size.width / text.length - cSize.width;
    int height = rect.size.height - cSize.height;
    CGPoint point;
    
    //依次绘制每一个字符,可以设置显示的每个字符的字体大小、颜色、样式等
    float pX, pY;
    for (int i = 0; i < text.length; i++)
    {
        pX = arc4random() % width + rect.size.width / text.length * i;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        
        [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:kFontSize}];
    }
    
    //调用drawRect：之前，系统会向栈中压入一个CGContextRef，调用UIGraphicsGetCurrentContext()会取栈顶的CGContextRef
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画线宽度
    CGContextSetLineWidth(context, kLineWidth);
    
    //绘制干扰的彩色直线
    for(int i = 0; i < kLineCount; i++)
    {
        //设置线的随机颜色
        UIColor *color = kRandomColor;
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        //设置线的起点
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextMoveToPoint(context, pX, pY);
        //设置线终点
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        //画线
        CGContextStrokePath(context);
    }
}
@end
