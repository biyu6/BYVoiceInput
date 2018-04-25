//
//  MBProgressHUD+LF.m
//  VOGUEPlayer
//
//  Created by elly on 16/3/21.
//  Copyright © 2016年 lekan. All rights reserved.
//

#import "MBProgressHUD+LF.h"
#import "UIImage+animatedGIF.h"

@implementation MBProgressHUD (LF)
#pragma mark 显示信息带菊花
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
    
}

+ (void)show:(NSString *)text view:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
}


#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}


+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        hud.label.font = [UIFont systemFontOfSize:12.f];
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view duration:(NSTimeInterval)duration {
    [self showMessage:message toView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUD];
    });
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}



+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (nil == view) view = [UIApplication sharedApplication].windows.lastObject;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)hideHUDWithMessage:(NSString *)message {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:message];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:1];
    
}


#pragma mark - 在屏幕下文仅仅显示文本

+ (void)inTheScreenBelowShowMessage:(NSString *)text view:(UIView *)view {
    if (nil == view) view         = [UIApplication sharedApplication].windows.lastObject;
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode                      = MBProgressHUDModeText;
    hud.label.text                = text;
    
    //置于屏幕底部中间位置
    hud.offset                    = CGPointMake(0, MBProgressMaxOffset);
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3.f];
}

#pragma mark - 显示自定义视图
+ (void)showCustomView:(UIView *)view text:(NSString *)text onContainerView:(UIView *)containerView {
    if (nil == containerView) {
        containerView = [UIApplication sharedApplication].windows.lastObject;
    }
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:containerView animated:YES];
    hud.mode                      = MBProgressHUDModeCustomView;
    hud.customView                = view;
    hud.label.text                = text;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showGifView:(NSString *)gifName text:(NSString *)text {
    if ([gifName containsString:@".gif"]) {
        gifName = [[gifName componentsSeparatedByString:@"."] firstObject];
    }
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]];
    
    UIImage *gif = [UIImage animatedImageWithAnimatedGIFData:gifData];
    
    [self showCustomView:[[UIImageView alloc] initWithImage:gif] text:text onContainerView:nil];
    
}

@end
