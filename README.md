# CaptchaView


### 使用coreGraphic绘制的本地验证码。多用于防止手机验证码的恶意获取
#### 展示效果
![Aaron Swartz](https://github.com/DongDongDongDong/CaptchaView/blob/master/CaptchaView.gif?raw=true)
### 使用步骤  

    _captchView = [[CaptchaView alloc]initWithFrame:self.view.bounds];  
  
    _captchView.backgroundColor = [UIColor lightGrayColor];  
    
    [self.view addSubview:_captchView];  
    
