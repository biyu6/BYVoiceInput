# 语音搜索

#####功能逻辑：按下按钮--说话--实时转成文字显示--松开按钮--开始搜索 

### 注意点
```
1.需要在info.plist中配置以下权限：
	1.语音识别的权限：Privacy - Speech Recognition Usage Description
	2.使用麦克风的权限：Privacy - Microphone Usage Description
2.需要监听app的挂起状态：
	1.很多的崩溃都是因为没有停止上一次的语音搜索，而又重新开始语音搜索造成的；
	2.本Demo中每次松开按钮就会停止语音搜索，但在未松开按钮的情况下挂起app后，按钮不会恢复（未停止语音引擎），再次回到界面处理语音按钮时会造成崩溃;
	3.不要监听进后台的状态，必须是监听挂起状态，因为在iPhone X中你可以通过下方的指示条挂起app而不会触发进后台的操作。

3.本demo中的一些提示框用的是对MBProgressHUD的二次封装
4.公用的宏自己处理一下，demo中是放在了pch文件中
5.由于使用的是系统的语音框架，所以只支持iOS10及以上版本
	
```

### 主要代码如下：
##### 1.AppDelegate中
```
- (void)applicationWillResignActive:(UIApplication *)application {//APP挂起后发送通知消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplicationState" object:@"kApplicationWillResignActive"];
}

```
##### 2.控制器中
```
/**语音搜索按钮*/
@property (nonatomic, strong)BYSoundRecordBtn *soundRecordBtn;

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
- (void)applictionState:(NSNotification *)notification {
    NSString *appState = [notification object];
    if ([appState isEqualToString:@"kApplicationWillResignActive"]) {//在挂起状态就结束语音搜索
        if (IOS_VERSION_10) {
            [_soundRecordBtn speechBtnStateWithSel:NO];
        }
    }
}
```

![image](https://github.com/biyu6/BYVoiceInput/blob/master/1.jpeg)
![image](https://github.com/biyu6/BYVoiceInput/blob/master/2.jpeg)
![image](https://github.com/biyu6/BYVoiceInput/blob/master/3.jpeg)