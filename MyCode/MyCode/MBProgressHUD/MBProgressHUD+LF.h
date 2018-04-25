//
//  MBProgressHUD+LF.h
//  VOGUEPlayer
//
//  Created by elly on 16/3/21.
//  Copyright © 2016年 lekan. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LF)
/**
 *  显示成功信息
 *
 *  @param success 成功的信息
 *  @param view    宿主视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/**
 *  显示错误信息
 *
 *  @param error 错误信息
 *  @param view  宿主view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;
/**
 *  显示信息
 *
 *  @param message 信息
 *  @param view    宿主view
 *
 *  @return MBProgressHUD instance
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  显示成功信息
 *
 *  @param success 成功信息(展示在window上)
 */
+ (void)showSuccess:(NSString *)success;
/**
 *  显示错误信息
 *
 *  @param error 错误信息 (展示在window上)
 */
+ (void)showError:(NSString *)error;

/**
 *  显示信息
 *
 *  @param message 信息(展示在window上)
 *
 *  @return MBProgressHUD instance
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
/**
 *  隐藏MBProgressHUD
 *
 *  @param view 宿主view
 */
+ (void)hideHUDForView:(UIView *)view;
/**
 *  隐藏MBProgressHUD
 */
+ (void)hideHUD;
/**
 *  显示信息后 隐藏MBProgressHUD
 *
 *  @param message 信息
 */
+ (void)hideHUDWithMessage:(NSString *)message;

/**
 *  仅仅显示文本信息
 *
 *  @param text 信息
 *  @param view 宿主view
 */
+ (void)show:(NSString *)text view:(UIView *)view;


/**
 *  在屏幕下文仅仅显示文本
 *
 *  @param text 显示文本
 *  @param view 显示在view上  默认显示在window
 */
+ (void)inTheScreenBelowShowMessage:(NSString *)text view:(UIView *)view;

/**
 *  显示自定义视图
 *
 *  @param view 自定义view
 *  @param text 文本
 *  containerView
 */
+ (void)showCustomView:(UIView *)view text:(NSString *)text onContainerView:(UIView *)containerView;

/**
 *  显示gif动画
 *
 *  @param gifName gif名称
 *  @param text    text
 */
+ (void)showGifView:(NSString *)gifName text:(NSString *)text;

@end
