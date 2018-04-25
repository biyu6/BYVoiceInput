//
//  MyVC.m
//  MyCode
//
//  Created by 胡忠诚 on 2018/4/24.
//  Copyright © 2018年 biyu6. All rights reserved.
//

#import "MyVC.h"
#import "BYSoundRecordBtn.h"//语音搜索按钮

@interface MyVC ()<UITextFieldDelegate>
/**搜索框*/
@property (nonatomic, strong) UITextField *searchTF;
/**语音搜索按钮*/
@property (nonatomic, strong)BYSoundRecordBtn *soundRecordBtn;

@end
@implementation MyVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubViews];
}
- (void)addSubViews{
    //输入框
    _searchTF = [[UITextField alloc] init];
    _searchTF.frame = CGRectMake(13, 200, ScreenWidth - 26 - 21, 35);
    _searchTF.font = [UIFont systemFontOfSize:IS_PHONE?14:20];
    _searchTF.backgroundColor = [UIColor cyanColor];
    _searchTF.placeholder = @"请输入搜索内容";
    _searchTF.delegate = self;
    _searchTF.returnKeyType = UIReturnKeySearch;
    [_searchTF addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_searchTF setValue:[UIColor grayColor]forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_searchTF];
    
    //搜索按钮
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-13-20, 200 +15/2, 20, 20)];
    [searchBtn setImage:[UIImage imageNamed:@"btn_magnifier_gray"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    //语音识别按钮（只支持iOS10以上）
    if (IOS_VERSION_10) {
        CGFloat spaceX = IS_iPhoneX ? 15 : 0 ;
        CGFloat soundBtnH = 40;//语音搜索按钮的高度
        CGRect soundRecordBtnFrame = CGRectMake(spaceX, ScreenHeight - soundBtnH - bot_H, ScreenWidth - 2*spaceX, soundBtnH);
        _soundRecordBtn = [[BYSoundRecordBtn alloc]initWithFrame:soundRecordBtnFrame];
        [self.view addSubview:_soundRecordBtn];
        [self.view bringSubviewToFront:_soundRecordBtn];
        [self addSoundRecordBtnClick];
        //监听app状态的改变 (很多的崩溃都是因为没有停止上一次的语音搜索，而又重新开始语音搜索造成的；本Demo中每次松开按钮就会停止语音搜索，但在未松开按钮的情况下挂起app后，按钮不会恢复（未停止语音引擎），再次回到界面处理语音按钮时会造成崩溃)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applictionState:) name:@"ApplicationState" object:nil];
    }
}
- (void)addSoundRecordBtnClick{//语音搜索按钮的点击事件
    WS(ws);
    _soundRecordBtn.clickSoundRecordStartBtn = ^{//开始接收语音
        ws.searchTF.text = @"";
    };
    _soundRecordBtn.clickSpeechRecognition = ^(NSString *sppechText) {//语音识别中的文字传送
        ws.searchTF.text = sppechText;
    };
    _soundRecordBtn.clickSoundRecordCancelBtn = ^{//取消语音搜索
        ws.searchTF.text = @"";
    };
    _soundRecordBtn.clickSoundRecordStopBtn = ^(NSString *speechText) {//立即搜索
        ws.searchTF.text = speechText;
        [ws searchBtnClick];
    };
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchTF endEditing:YES];
}

#pragma mark- UITextField处理
- (void)textFieldDidChange{
    NSLog(@"输入的内容：%@",_searchTF.text);
}
- (void)searchBtnClick{//点击了搜索按钮
    NSLog(@"点击了搜索按钮：%@",_searchTF.text);
}

#pragma mark- app状态改变的处理
- (void)applictionState:(NSNotification *)notification {
    NSString *appState = [notification object];
    if ([appState isEqualToString:@"kApplicationWillResignActive"]) {//在挂起状态就结束语音搜索
        //不要监听进后台的状态，必须是监听挂起状态，因为在iPhone X中你可以通过下方的指示条挂起app而不会触发进后台的操作
        if (IOS_VERSION_10) {
            [_soundRecordBtn speechBtnStateWithSel:NO];
        }
    }
}
- (BOOL)prefersHomeIndicatorAutoHidden{//自动隐藏iPhoneX下面的横条
    return YES;
}


@end
