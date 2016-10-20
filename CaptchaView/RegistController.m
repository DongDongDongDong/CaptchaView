//
//  RegistController.m
//  MaintenanceProject
//
//  Created by andylau on 16/9/23.
//  Copyright © 2016年 andylau. All rights reserved.
//
#import "RegistController.h"
#import "MyTextField.h"
#import "CaptchaView.h"
@interface RegistController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *randomCodeView;
@property (weak, nonatomic) IBOutlet MyTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet MyTextField *phoneVerifyCodeTextField;
@property (weak, nonatomic) IBOutlet MyTextField *codeViewTextField;

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *imageVerifyView;
@property (weak, nonatomic) IBOutlet UIView *phoneVerifyView;

@property (weak, nonatomic) IBOutlet UIButton *getPhoneCodeBtn;

@property (nonatomic, strong) CaptchaView *captchView;

@end

@implementation RegistController

- (CaptchaView *)captchView{
    if (_captchView == nil) {
        _captchView = [[CaptchaView alloc]initWithFrame:self.randomCodeView.bounds];
        _captchView.backgroundColor = [UIColor lightGrayColor];
        [self.randomCodeView addSubview:_captchView];
    }
    return _captchView;
}

#pragma mark LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeViewTextField.delegate = self;
    [self.getPhoneCodeBtn setBackgroundImage:[self createImageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [self.getPhoneCodeBtn setEnabled:NO];
    [self addTextFieldImg];
    [self setupOuterViewBorder:self.phoneView];
    [self setupOuterViewBorder:self.imageVerifyView];
    [self setupOuterViewBorder:self.phoneVerifyView];
    [self setKeyboardType];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.captchView) {
        // 调用一次
    }
}

#pragma mark setup UI

- (void)addTextFieldImg{
    UIImageView *userImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone"]];
    userImg.frame = CGRectMake(0, 0, 8, 15);
    self.phoneTextField.leftView = userImg;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setupOuterViewBorder:(UIView *)view{
    view.layer.borderWidth = 0.8f;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
}


- (void)setKeyboardType{
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneVerifyCodeTextField.keyboardType = UIKeyboardTypePhonePad;
    self.codeViewTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.codeViewTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeViewTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
}


#pragma mark TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(str.length > 4){
        textField.text = [str substringToIndex:4];
        return NO;
    }else if(str.length == 4){
        if ([str isEqualToString:self.captchView.changeString]) {
            [self.getPhoneCodeBtn setEnabled:YES];
        }else{
            [self shakeAction];
            [self.getPhoneCodeBtn setEnabled:NO];
        }
        return YES;
    }else{
        [self.getPhoneCodeBtn setEnabled:NO];
        return YES;
    }
    
}



#pragma mark privateMethod
- (void)shakeAction
{
    // 晃动次数
    static int numberOfShakes = 4;
    // 晃动幅度（相对于总宽度）
    static float vigourOfShake = 0.04f;
    // 晃动延续时常（秒）
    static float durationOfShake = 0.5f;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 方法一：绘制路径
    CGRect frame = self.imageVerifyView.frame;
    // 创建路径
    CGMutablePathRef shakePath = CGPathCreateMutable();
    // 起始点
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame));
    for (int index = 0; index < numberOfShakes; index++)
    {
        // 添加晃动路径 幅度由大变小
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
        CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
    }
    // 闭合
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    // 释放
    CFRelease(shakePath);
    
    [self.imageVerifyView.layer addAnimation:shakeAnimation forKey:kCATransition];
}


- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
