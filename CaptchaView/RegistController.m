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
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
            anim.repeatCount = 1;
            anim.values = @[@-20, @20, @-20];
            [self.captchView.layer addAnimation:anim forKey:nil];
            [self.imageVerifyView.layer addAnimation:anim forKey:nil];
            [self.getPhoneCodeBtn setEnabled:NO];
        }
        return YES;
    }else{
        [self.getPhoneCodeBtn setEnabled:NO];
        return YES;
    }
    
}

#pragma mark privateMethod

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
