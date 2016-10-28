//
//  CaptchaView.h
//  CaptchaView
//
//  Created by andylau on 2016/10/18.
//  Copyright © 2016年 andylau. All rights reserved.
//
typedef void(^changeCaptchaBlock)();

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CaptchaView : UIView

@property (nonatomic, retain) NSArray *changeArray; //字符素材数组

@property (nonatomic, retain) NSMutableString *changeString;  //验证码的字符串

@property (nonatomic, copy) changeCaptchaBlock changeCaptchaBlock; // 每次刷新验证码后的操作，若无此需求，可忽略此属性


@end
