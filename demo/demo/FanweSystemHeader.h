//
//  FanweSystemHeader.h
//  FanweApp
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 xfg. All rights reserved.
//  系统宏

#ifndef FanweSystemHeader_h
#define FanweSystemHeader_h

// 屏幕frame,bounds,size,scale
#define kScreenFrame            [UIScreen mainScreen].bounds
#define kScreenBounds           [UIScreen mainScreen].bounds
#define kScreenSize             [UIScreen mainScreen].bounds.size
#define kScreenScale            [UIScreen mainScreen].scale
#define kScreenW                [[UIScreen mainScreen] bounds].size.width
#define kScreenH                [[UIScreen mainScreen] bounds].size.height
#define kScaleW                 (kScreenW)*(kScreenScale)
#define kScaleH                 (kScreenH)*(kScreenScale)

#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"

#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];
#define PFR8Font [UIFont fontWithName:PFR size:8];

// 主窗口的宽、高
#define kMainScreenWidth        MainScreenWidth()
#define kMainScreenHeight       MainScreenHeight()
static __inline__ CGFloat MainScreenWidth()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}

static __inline__ CGFloat MainScreenHeight()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}

// 状态栏、导航栏、标签栏高度
#define kStatusBarHeight        ([UIApplication sharedApplication].statusBarFrame.size.height)
#define kNavigationBarHeight    (self.navigationController.navigationBar.frame.size.height)
#define kTabBarHeight           (self.tabBarController.tabBar.frame.size.height)
#define kTopTopHeight           (kStatusBarHeight + kNavigationBarHeight)

// 日志输出宏定义
#ifdef DEBUG
// 调试状态
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
// 发布状态
#define NSLog(...)
#endif


#define scale_hight1 SCREEN_HEIGHT < 600 ? 50 : 55
#define scale_hight SCREEN_HEIGHT > 667 ? 60 : scale_hight1


#endif /* FanweSystemHeader_h */
