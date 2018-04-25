//
//  MBProgressHUD+BY.m
//  MyCodeBasics
//
//  Created by sinoaudit on 2017/6/28.
//  Copyright © 2017年 huzhongcheng. All rights reserved.
//

#import "MBProgressHUD+BY.h"

@implementation MBProgressHUD (BY)
//信息提示(提示文字、HUD展示的view、展示的时间）
+ (MBProgressHUD *)showInformation:(NSString *)information toView:(UIView *)view andAfterDelay:(float)afterDelay{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = information;
    hud.label.numberOfLines = 0;
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:afterDelay];
    
    return hud;
}

//自定义view、提示文字、HUD展示的view、展示时间
+ (void)showCustomview:(UIView *)customview andTextString:(NSString *)textString toView:(UIView *)view andAfterDelay:(float)afterDelay{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.customView = customview;
    hud.square = YES;
    hud.label.text = textString;
    [hud hideAnimated:YES afterDelay:afterDelay];
}

//隐藏 HUD
+ (void) dissmissShowView:(UIView *)showView {
    if (showView == nil) {
        showView = (UIView*)[[[UIApplication sharedApplication]delegate]window];
    }
    showView.alpha = 1;
    [self hideHUDForView:showView animated:YES];
}

//显示 HUD（iamgeArr 为 loading 图片数组，如果为nil 则为默认的loading样式）
+ (instancetype) showHUDWithImageArr:(NSMutableArray *)imageArr andShowView:(UIView *)showView{
    if (showView == nil) {
        showView  = (UIView *)[[UIApplication sharedApplication].delegate window];
    }
    showView.backgroundColor = [UIColor grayColor];
    showView.alpha = 0.7;
    if (imageArr == nil) {
        return [self showHUDAddedTo:showView animated:YES];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *imaegCustomView = [[UIImageView alloc] init];
        imaegCustomView.animationImages = imageArr;
        [imaegCustomView setAnimationRepeatCount:0];
        [imaegCustomView setAnimationDuration:(imageArr.count + 1) * 0.075];
        [imaegCustomView startAnimating];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        hud.customView = imaegCustomView;
        hud.square = NO;
        return hud;
    }
}

//显示信息和信息上的model，并指定是在window上展示还是在当前控制器的View上展示
+ (void)showMessage:(NSString *)message MBPMode:(MBProgressHUDMode )mode isWindiw:(BOOL)isWindow{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
//        imgNameStr = imgNameStr == nil ? @"" : imgNameStr;
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgNameStr]];
    hud.mode = mode;
    [hud hideAnimated:YES afterDelay:2.0];
}
+ (void)showMessage:(NSString *)message afterDelay:(NSTimeInterval)delay MBPMode:(MBProgressHUDMode )mode isWindiw:(BOOL)isWindow{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = mode;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow{
//    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[[AppDelegate shareAppDelegate] getCurrentUIVC].view;
    UIView  *view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        [hud showAnimated:YES];
    }
    hud.minSize = CGSizeMake(300, 50);
    hud.label.text=message?message:@"加载中...";
    hud.label.font=[UIFont systemFontOfSize:15];
    hud.label.textColor= [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.3];
    hud.removeFromSuperViewOnHide = YES;
    [hud setContentColor:[UIColor whiteColor]];
    return hud;
}


@end
