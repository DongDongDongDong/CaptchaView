//
//  MyTextField.m
//  CheckAuto3-0
//
//  Created by andylau on 15/6/15.
//  Copyright (c) 2015年 youxinpai. All rights reserved.
//

#define TEXTFIELD_TEXT_LEFT_PADDING 10
#define TEXTFIELD_LEFTVIEW_LEFT_PADDING 5
#import "MyTextField.h"

@implementation MyTextField

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += TEXTFIELD_LEFTVIEW_LEFT_PADDING;
    return iconRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x += TEXTFIELD_TEXT_LEFT_PADDING;
    return textRect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    textRect.origin.x += TEXTFIELD_TEXT_LEFT_PADDING;
    return textRect;
}

@end
