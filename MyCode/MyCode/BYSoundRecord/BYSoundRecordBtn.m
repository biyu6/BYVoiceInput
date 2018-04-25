//
//  BYSoundRecordBtn.m
//  MyCode
//
//  Created by 胡忠诚 on 2018/4/24.
//  Copyright © 2018年 biyu6. All rights reserved.
//语音识别集成Btn

#import "BYSoundRecordBtn.h"
#import <Speech/Speech.h>//语音识别的系统类


//按钮的颜色和文字
#define norColor [UIColor colorWithRed:0/255.0f green:162/255.0f blue:226/255.0f alpha:1.0]
#define highColor [UIColor colorWithRed:175/255.0f green:175/255.0f blue:175/255.0f alpha:1.0]
static NSString *norText = @"按住开始语音搜索";
static NSString *highText = @"松开开始搜索";

@interface BYSoundRecordBtn()<SFSpeechRecognizerDelegate>
/**对象处理了语音识别请求。他给语音识别提供了语音输入*/
@property (nonatomic, strong)SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
/**对象告诉了你语音识别对象的结果。拥有这个对象可以很方便的让你删除或中断任务*/
@property (nonatomic, strong)SFSpeechRecognitionTask *recognitionTask;
/**语音引擎*/
@property (nonatomic, strong)AVAudioEngine *audioEngine;
@property (nonatomic, strong)SFSpeechRecognizer *speechRecognizer;
/**语音识别的文字*/
@property (nonatomic, copy)NSString *speechText;

@end
@implementation BYSoundRecordBtn
#pragma mark- init初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.titleLabel.font = [UIFont systemFontOfSize:IS_PHONE?17:25];
        [self setTintColor:[UIColor whiteColor]];
        [self setTitle:norText forState:UIControlStateNormal];
        [self setTitle:highText forState:UIControlStateHighlighted];
        [self setBackgroundImage:[self imageWithColor:norColor size:self.frame.size] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:highColor size:self.frame.size] forState:UIControlStateHighlighted];
        if (IS_iPhoneX) {
            self.layer.cornerRadius = 20;
            self.layer.masksToBounds = YES;
        }
        //        self.titleEdgeInsets = UIEdgeInsetsMake(-bot_H, 0, 0, 0);//如果是iPhone X 文字往上偏移-34
        //增加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.1;
        [self addGestureRecognizer:longPress];
        //初始化语音控件
        [self initAudioAndSpeech];
    }
    return self;
}
- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer{//如果在语音按钮范围内松手，停止语音识别；否则就是取消识别
    CGPoint point = [gestureRecognizer locationInView:self];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self audioStart];
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.layer containsPoint:point]) {//在当前的按钮中
            [self audioStop];
        }else{//不在当前的按钮中
            [self audioCancel];
        }
    }else{//其他手势
    }
}

#pragma mark- 用户交互
- (void)audioStart{//开始录音
    NSLog(@"【biyu6调试信息】1=======开始录音========");
    [self speechBtnStateWithSel:YES];
    _speechText = @"";
    if (self.clickSoundRecordStartBtn) {
        self.clickSoundRecordStartBtn();
    }
    [MBProgressHUD showMessage:@"向上滑动取消搜索" afterDelay:1.0 MBPMode:5 isWindiw:YES];
    [self speechBtnClick];
}
- (void)audioStop{//结束录音
    NSLog(@"【biyu6调试信息】2=======结束录音=====");
    WS(ws);
    [self speechBtnStateWithSel:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (ws.speechText.length > 0) {
            if (self.clickSoundRecordStopBtn) {
                self.clickSoundRecordStopBtn(ws.speechText);
            }
        }else{
            [MBProgressHUD showMessage:@"未能获取语音内容，请重试！" afterDelay:1.0 MBPMode:5 isWindiw:YES];
        }
    });
}
- (void)audioCancel{//取消录音
    NSLog(@"【biyu6调试信息】3=======取消录音========");
    [self speechBtnStateWithSel:NO];
    if (self.clickSoundRecordCancelBtn) {
        self.clickSoundRecordCancelBtn();
    }
}
- (void)speechBtnStateWithSel:(BOOL)isSel{
    if (isSel) {//点击后
        [self setTitle:highText forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:highColor size:self.frame.size] forState:UIControlStateNormal];
    }else{//默认状态--结束录音
        [self setTitle:norText forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:norColor size:self.frame.size] forState:UIControlStateNormal];
        [self completeBtnClick];
    }
}

#pragma mark- 语音搜索相关
- (void)initAudioAndSpeech{//初始化
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
    _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:usLocale];
    _speechRecognizer.delegate = self;
    //申请用户语音识别权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status != SFSpeechRecognizerAuthorizationStatusAuthorized) {//如果用户没有授权语音识别（用户尚未进行选择、拒绝授权、设备不支持语音识别）
            NSLog(@"【biyu6调试信息】警告：用户还没有授权语音识别");
        }
    }];
    _audioEngine = [[AVAudioEngine alloc] init];
}
- (void)speechBtnClick{//语音搜索授权
    if (_audioEngine.isRunning) {//语音引擎 运行中
        [_recognitionRequest endAudio];
        [_audioEngine stop];
    }else{
        if ([self checkMicrophoneStatus] == 3) {//已经授权
            [self startRecording];
        }else if ([self checkMicrophoneStatus] == 2){//未授权(单纯的未授权、家长控制未授权)
            [MBProgressHUD showMessage:@"启动麦克风失败，请在设置中授予CNTraveler麦克风的权限" afterDelay:2.0 MBPMode:5 isWindiw:YES];
        }else if ([self checkMicrophoneStatus] == 1){//没有询问是否开启麦克风
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                    if (granted) {
                        [self startRecording];
                    } else {
                        [MBProgressHUD showMessage:@"启动麦克风失败，请在设置中授予CNTraveler麦克风的权限" afterDelay:2.0 MBPMode:5 isWindiw:YES];
                    }
                }];
            }
        }
    }
}
- (NSInteger)checkMicrophoneStatus{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined://没有询问是否开启麦克风
            return 1;
            break;
        case AVAuthorizationStatusRestricted://未授权，家长限制
            return 2;
            break;
        case AVAuthorizationStatusDenied://玩家未授权
            return 2;
            break;
        case AVAuthorizationStatusAuthorized://玩家授权
            return 3;
            break;
        default:
            break;
    }
    return 4;
}
- (void)startRecording{//启动语音引擎
    WS(ws);
    //检查 recognitionTask 是否在运行。如果在就取消任务和识别
    if (_recognitionTask != nil) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    //创建一个 AVAudioSession来为记录语音做准备。在这里我们设置session的类别为recording，模式为measurement，然后激活它。注意设置这些属性有可能会抛出异常，因此你必须把他们放入try catch语句里面。
    NSError *categoryError;
    NSError *modeError;
    NSError *ActiveError;
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&categoryError];//仅用来录音，无法播放音频
        [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeMeasurement error:&modeError];//AV音频会话模式测量
        [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&ActiveError];//激活自己通知其他背景音停用
    } @catch (NSException *exception) {
        NSLog(@"【biyu6调试信息】录音功能错误 = %@",categoryError);
        NSLog(@"【biyu6调试信息】音频会话模式测量错误 = %@",modeError);
        NSLog(@"【biyu6调试信息】激活自己通知其他背景音停用错误 = %@",ActiveError);
    }
    //实例化recognitionRequest。在这里我们创建了SFSpeechAudioBufferRecognitionRequest对象。稍后我们利用它把语音数据传到苹果后台。
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    //检查 audioEngine（你的设备）是否有做录音功能作为语音输入。如果没有，我们就报告一个错误。
    if (!_audioEngine.inputNode) {
        NSLog(@"【biyu6调试信息】音频引擎没有输入节点");
    }
    //检查recognitionRequest对象是否被实例化和不是nil。
    if (!_recognitionRequest) {
        NSLog(@"【biyu6调试信息】无法创建一个 SFSpeechAudioBufferRecognitionRequest 对象,ios10以上才可以使用");
    }
    //当用户说话的时候让recognitionRequest报告语音识别的部分结果 。
    _recognitionRequest.shouldReportPartialResults = YES;
    //提出语音识别的请求，如果请求的shouldReportPartialResults属性是YES,将会返回处理结果，在语音输入时会不断处理，最后给出一个结果或者一个错误
    _recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"【biyu6调试信息】语音识别失败：%@",error);
        }else{
            //定义一个布尔值决定识别是否已经结束。
            BOOL isFinal = NO;
            NSString *resultStr = result.bestTranscription.formattedString;//语音识别的内容
            NSLog(@"【biyu6调试信息】语音识别的内容：%@",resultStr);
            ws.speechText = [[resultStr componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
            NSLog(@"【biyu6调试信息】去除标点后的语音识别内容：%@",ws.speechText);
            if (self.clickSpeechRecognition) {//语音识别中的文字传送
                self.clickSpeechRecognition(ws.speechText);
            }
            //
            isFinal = (result.isFinal);//是否是最终的处理结果
            if (isFinal) {//如果是最终结果--停止语音输入--在按钮松手后就会停止，所以这里就给注释掉了
//                [_audioEngine stop];
//                [_audioEngine.inputNode removeTapOnBus:0];
//                _recognitionRequest = nil;
//                _recognitionTask = nil;
            }
        }
    }];
    //向 recognitionRequest增加一个语音输入。注意在开始了recognitionTask之后增加语音输入是OK的。Speech Framework 会在语音输入被加入的同时就开始进行解析识别。
    AVAudioFormat *avFormat = [_audioEngine.inputNode outputFormatForBus:0];
    [_audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:avFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [ws.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    //准备并且开始audioEngine。
    [_audioEngine prepare];
    NSError *startError;
    @try {
        [_audioEngine startAndReturnError:&startError];
    } @catch (NSException *exception) {
        NSLog(@"【biyu6调试信息】由于错误，音频引擎无法启动:%@",startError);
    }
}
- (void)completeBtnClick{//完成语音搜索
    if (_audioEngine.isRunning) {
        NSError *categoryError;
        NSError *modeError;
        NSError *ActiveError;
        @try {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:&categoryError];//会停止其他程序的音频播放。当设备被设置为静音模式，app也同样被停止
            //            [[AVAudioSession sharedInstance] setMode:AVAudioSessionCategoryPlayback error:&modeError];//只用于播放,默认会引起不支持混音的App中断，静音或锁屏时不静音
            [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeMeasurement error:&modeError];//AV音频会话模式测量
            [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&ActiveError];//激活自己通知其他背景音停用
        } @catch (NSException *exception) {
            NSLog(@"【biyu6调试信息】停止其他App音频播放错误 = %@",categoryError);
            NSLog(@"【biyu6调试信息】播放错误 = %@",modeError);
            NSLog(@"【biyu6调试信息】激活自己通知其他背景音停用错误 = %@",ActiveError);
        }
        [_audioEngine stop];
        [_recognitionRequest endAudio];
        [_audioEngine.inputNode removeTapOnBus:0];
        _recognitionRequest = nil;
        _recognitionTask = nil;
    }else{
        if (_recognitionRequest) {
            [_recognitionRequest endAudio];
        }
    }
}

#pragma mark- 其他
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{//颜色转图片
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
