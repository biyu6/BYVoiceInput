//
//  BYSoundRecordBtn.h
//  MyCode
//
//  Created by 胡忠诚 on 2018/4/24.
//  Copyright © 2018年 biyu6. All rights reserved.
//语音识别集成Btn

#import <UIKit/UIKit.h>

@interface BYSoundRecordBtn : UIButton
/**点击了开始录音*/
@property (nonatomic, copy)void (^clickSoundRecordStartBtn)(void);
/**语音识别中的文字传送*/
@property (nonatomic, copy)void (^clickSpeechRecognition)(NSString *sppechText);
/**点击了取消录音*/
@property (nonatomic, copy)void (^clickSoundRecordCancelBtn)(void);
/**点击了结束录音*/
@property (nonatomic, copy)void (^clickSoundRecordStopBtn)(NSString *speechText);

//按钮的状态--为NO结束录音--关闭语音引擎
- (void)speechBtnStateWithSel:(BOOL)isSel;


@end
