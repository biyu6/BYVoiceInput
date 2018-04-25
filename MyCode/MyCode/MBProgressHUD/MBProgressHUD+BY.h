//
//  MBProgressHUD+BY.h
//  MyCodeBasics
//
//  Created by sinoaudit on 2017/6/28.
//  Copyright © 2017年 huzhongcheng. All rights reserved.
//对MBProgressHUD 的二次封装

#import "MBProgressHUD.h"

@interface MBProgressHUD (BY)
/**信息提示(提示文字、HUD展示的view、展示的时间）*/
+ (MBProgressHUD *)showInformation:(NSString *)information toView:(UIView *)view andAfterDelay:(float)afterDelay;

/**自定义view、提示文字、HUD展示的view、展示时间*/
+ (void)showCustomview:(UIView *)customview andTextString:(NSString *)textString toView:(UIView *)view andAfterDelay:(float)afterDelay;

/**隐藏 HUD*/
+ (void) dissmissShowView:(UIView *)showView;

/**显示 HUD（iamgeArr 为 loading 图片数组，如果为nil 则为默认的loading样式）*/
+ (instancetype) showHUDWithImageArr:(NSMutableArray *)imageArr andShowView:(UIView *)showView;

//显示信息和信息上的model，并指定是在window上展示还是在当前控制器的View上展示
+ (void)showMessage:(NSString *)message MBPMode:(MBProgressHUDMode )mode isWindiw:(BOOL)isWindow;
+ (void)showMessage:(NSString *)message afterDelay:(NSTimeInterval)delay MBPMode:(MBProgressHUDMode )mode isWindiw:(BOOL)isWindow;

@end
