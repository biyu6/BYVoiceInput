//
//  BYPrefix.h
//  MyCode
//
//  Created by 胡忠诚 on 2018/4/25.
//  Copyright © 2018年 biyu6. All rights reserved.
//

#ifndef BYPrefix_h
#define BYPrefix_h

//设备的判断
#define IS_PHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断版本
#define IOS_VERSION_10 ([[UIDevice currentDevice] systemVersion].integerValue >= 10)

//宽高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define bot_H (IS_iPhoneX ? 34 : 0)

//其他
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

#import "MBProgressHUD+BY.h"//提示框


#endif /* BYPrefix_h */
