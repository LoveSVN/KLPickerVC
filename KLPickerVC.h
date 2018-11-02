//
//  KLPickerVC.h
//  FanweApp
//
//  Created by 张晓亮 on 2018/10/24.
//  Copyright © 2018 xfg. All rights reserved.
//

//有些第三方不需要就干掉吧，说实话刚开这个公司，感觉有些东西 有BUG
#import <UIKit/UIKit.h>
#import "FanweSystemHeader.h"
#import "UIView+Layout.h"
#import "Masonry.h"
NS_ASSUME_NONNULL_BEGIN


@interface KLPickerVC : UIViewController
//日期选择器
- (void)showDatePickerWithDefaultDate:(NSDate *)defaultDate cancle:(void(^)())cancle doAtcion:(void(^)(id data))doAction;

//省市Pickerview
- (void)showAddressPickerViewWithCancle:(void(^)())cancle doAtcion:(void(^)(id data))doAction;

//通用数据选择器
- (void)showPickerWithWithComponent:(NSInteger)component
            numberOfRowsInComponent:(NSInteger(^)(UIPickerView *pickerView,NSInteger componentIndex))numberOfRows
                           cellData:(UIView *(^)(UIPickerView *pickerView,NSInteger row,NSInteger component,UIView *reusingView))cellData
                             cancle:(void(^)())cancle
                           doAtcion:(void(^)(id data))doAction;


- (void)dissmis:(void(^)(BOOL finished))complate;
@end



@interface KLPickerView : UIView
+ (instancetype)datePickWithMode:(UIDatePickerMode)datePickerMode
           defaultDate:(NSDate *)defaultDate
                cancle:(void(^)())cancle
              doAtcion:(void(^)(id data))doAction;

+ (instancetype)dataPikcerWithComponent:(NSInteger)component
                numberOfRowsInComponent:(NSInteger(^)(UIPickerView *picView,NSInteger componentIndex))numberOfRows
                               cellData:(UIView *(^)(UIPickerView *picView,NSInteger row,NSInteger component,UIView *reusingView))cellData
                                 cancle:(void(^)())cancle
                               doAtcion:(void(^)(id data))doAction;
@end

NS_ASSUME_NONNULL_END
