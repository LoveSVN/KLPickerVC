//
//  KLPickerVC.m
//  FanweApp
//
//  Created by 张晓亮 on 2018/10/24.
//  Copyright © 2018 xfg. All rights reserved.
//

#import "KLPickerVC.h"
#import "areaModel.h"
@interface KLPickerVC ()
@property(nonatomic,strong)KLPickerView *picker;
@end

@implementation KLPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
}

- (void)showDatePickerWithDefaultDate:(NSDate *)defaultDate cancle:(void(^)())cancle doAtcion:(void(^)(id data))doAction {

    [self.view setNeedsDisplay];
    WEAKSELF;
    KLPickerView *pickerView = [KLPickerView datePickWithMode:UIDatePickerModeDate defaultDate:defaultDate cancle:^{

        [weakSelf doTapChange:nil];
        if (cancle) {
            cancle();
        }

    } doAtcion:^(id  _Nonnull data) {

        [weakSelf doTapChange:nil];
        if (doAction) {
            doAction(data);
        }

    }];
    pickerView.width = kScreenW;
    pickerView.height = 265;
    pickerView.x = 0;
    pickerView.y = kScreenH;
    [self.view addSubview:pickerView];

    [UIView animateWithDuration:0.3 animations:^{

        pickerView.y = kScreenH - pickerView.height;
        
    } completion:^(BOOL finished) {

    }];
    self.picker = pickerView;



    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    //    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)showPickerWithWithComponent:(NSInteger)component
            numberOfRowsInComponent:(NSInteger(^)(UIPickerView *pickerView,NSInteger componentIndex))numberOfRows
                           cellData:(UIView *(^)(UIPickerView *pickerView,NSInteger row,NSInteger component,UIView *reusingView))cellData
                             cancle:(void(^)())cancle
                           doAtcion:(void(^)(id data))doAction {


    [self.view setNeedsDisplay];
    WEAKSELF;
    KLPickerView *pickerView = [KLPickerView dataPikcerWithComponent:component numberOfRowsInComponent:numberOfRows cellData:cellData cancle:^{

        [weakSelf doTapChange:nil];
        if (cancle) {
            cancle();
        }

    } doAtcion:^(id  _Nonnull data) {

        [weakSelf doTapChange:nil];
        if (doAction) {

            doAction(data);
        }
    }];
    pickerView.width = kScreenW;
    pickerView.height = 265;
    pickerView.x = 0;
    pickerView.y = kScreenH;
    [self.view addSubview:pickerView];

    [UIView animateWithDuration:0.3 animations:^{

        pickerView.y = kScreenH - pickerView.height;

    } completion:^(BOOL finished) {

    }];
    self.picker = pickerView;



    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange:)];
    //    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

- (void)showAddressPickerViewWithCancle:(void(^)())cancle doAtcion:(void(^)(id data))doAction {


    WEAKSELF;
    [[HUDHelper sharedInstance] syncLoading:@"" inView:self.view];
    [self getProvincesAndCitiesSucess:^(NSArray *dataList) {
        NSLog(@"%@---",dataList);

        [[HUDHelper sharedInstance] syncStopLoading];


        [weakSelf showPickerWithWithComponent:2 numberOfRowsInComponent:^NSInteger(UIPickerView *pickerView,NSInteger componentIndex) {

            if (componentIndex == 0) {

                return dataList.count;
            } else {
                NSInteger selectedIndex = [pickerView selectedRowInComponent:0];
                areaModel *model = dataList[selectedIndex];
                return [model.modelArray count];
            }

        } cellData:^UIView * _Nonnull(UIPickerView *pickerView,NSInteger row, NSInteger component,UIView *reusingView) {

            UILabel *lable = (UILabel *)reusingView;
            if (!lable) {
                lable = [UILabel new];
                lable.font = kAppPingFangSCMediumTextFont(18.0);
                lable.textColor = colorWithStr(@"333333");
                lable.textAlignment = component?NSTextAlignmentLeft:NSTextAlignmentRight;
            }


            if (component == 0) {

                areaModel *model = dataList[row];
                lable.text = [NSString stringWithFormat:@"%@      ",model.name];
            }else
            {
                NSInteger selectedIndex = [pickerView selectedRowInComponent:0];
                areaModel *model = dataList[selectedIndex];
                if (row < model.modelArray.count) {

                    lable.text = [NSString stringWithFormat:@"      %@",model.modelArray[row]];
                }else {

                    [pickerView selectRow:model.modelArray.count -1 inComponent:1 animated:YES];
                }

            }

            return lable;

        } cancle:^{

            if (cancle) {
                cancle();
            }
        } doAtcion:^(id  _Nonnull data) {

            if (doAction) {

                NSArray *arry = data;
                areaModel *addressInfo = dataList[[arry.firstObject integerValue]];
                NSArray *callbaclData = @[addressInfo.name,addressInfo.modelArray[[arry.lastObject integerValue]]];
                doAction(callbaclData);
            }
        }];


    } failureBlock:^{

        NSLog(@"failure ==");
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"请求失败"];

    }];


}


- (void)getProvincesAndCitiesSucess:(void(^)(NSArray *dataList))sucess failureBlock:(void(^)())failure{

    //存版本
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"versions.plist"];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    NSString *versions = [dict1 objectForKey:@"versions"];
    NSMutableArray *arryM = nil;
    if ([versions isEqualToString:[GlobalVariables sharedInstance].appModel.region_versions]) {
        //获取Documents目录
        NSString *docPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        //还要指定存储文件的文件名称,仍然使用字符串拼接
        NSString *filePath2 = [docPath2 stringByAppendingPathComponent:@"Province.plist"];
        arryM = [NSMutableArray arrayWithContentsOfFile:filePath2];

        if (arryM && [arryM isKindOfClass:[NSMutableArray class]]) {

            NSArray *tmpArry = [self setRegionList:arryM];
            if (sucess) {
                sucess(tmpArry);
            }

        }else {
            arryM = [[NSMutableArray alloc]init];
            WEAKSELF;
            [self loadNetSucess:^(NSMutableArray *dataList) {

                NSArray *list = [weakSelf setRegionList:arryM];
                if (sucess) {
                    sucess(list);
                }


            } FailureBlock:^(NSError *error) {

                if (failure) {
                    failure();
                }
            }];
        }

    } else {
        arryM = [[NSMutableArray alloc]init];
        WEAKSELF;
        [self loadNetSucess:^(NSMutableArray *dataList) {

            NSArray *list = [weakSelf setRegionList:arryM];
            if (sucess) {
                sucess(list);
            }
        } FailureBlock:^(NSError *error) {
            if (failure) {
                failure();
            }
        }];
    }

}

- (NSArray *)setRegionList:(NSMutableArray *)allDataArray {

    NSMutableArray *arryM = @[].mutableCopy;
    for (NSDictionary *dict in allDataArray)
    {
        areaModel *model = [[areaModel alloc]init];

        if ([[dict toString:@"region_level"] isEqualToString:@"2"])
        {
            // NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            model.id = [dict toString:@"id"];
            model.pid= [dict toString:@"pid"];
            model.name = [dict toString:@"name"];
            model.region_level = [dict toString:@"region_level"];
            model.modelArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict1 in allDataArray)
            {
                if ([model.id isEqualToString:[dict1 toString:@"pid"]])
                {
                    [model.modelArray addObject:[dict1 toString:@"name"]];//存城市
                }
            }
            [arryM addObject:model];
        }
    }

    return arryM;
}

//加载数据
- (void)loadNetSucess:(void(^)(NSMutableArray *dataList))sucess FailureBlock:(void(^)(NSError *error))failureBlock
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"region_list" forKey:@"act"];
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             //存版本
             NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
             NSString *filePath = [cachePath stringByAppendingPathComponent:@"versions.plist"];
             NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
             [dict1 setObject:[responseJson toString:@"region_versions"] forKey:@"versions"];
             [dict1 writeToFile:filePath atomically:YES];


             NSArray *areaArray = [responseJson objectForKey:@"region_list"];
             if (areaArray)
             {
                 if (areaArray.count > 0  && [areaArray isKindOfClass:[NSArray class]])
                 {
                     //获取Documents目录
                     NSString *docPath2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                     //还要指定存储文件的文件名称,仍然使用字符串拼接
                     NSString *filePath2 = [docPath2 stringByAppendingPathComponent:@"Province.plist"];
                     NSLog(@"filePath2==%@",filePath2);
                     [areaArray writeToFile:filePath2 atomically:YES];
                     if (sucess) {
                         sucess(areaArray);
                     }
                 }
             }
         }
     } FailureBlock:^(NSError *error)
     {
         NSLog(@"error==%@",error);
         failureBlock(error);
     }];
}

- (void)doTapChange:(UITapGestureRecognizer *)tapGestureRecognizer {

    WEAKSELF;
    [self dissmis:^(BOOL finished) {

        [weakSelf dismissViewControllerAnimated:NO completion:NULL];
    }];


}

- (void)dissmis:(void(^)(BOOL finished))complate {

    [UIView animateWithDuration:0.3 animations:^{

        self.picker.y = self.view.height;
    } completion:^(BOOL finished) {
        complate(finished);
        [self.picker removeFromSuperview];
    }];



}

@end

typedef enum : NSUInteger {
    KLPickerTypeDatePikcer,
    KLPickerTypeDataPikcer,
} KLPickerType;



@interface KLPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIView *barView;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,copy)void(^cancleBlock)();
@property(nonatomic,copy)void(^doBlock)(id data);
@property(nonatomic,assign)KLPickerType pickerType;
//datePicker
@property(nonatomic,strong)UIDatePicker *datePicker;


//普通picker
@property(nonatomic,strong)UIPickerView *picker;
@property(nonatomic,assign)NSInteger component;
@property(nonatomic,copy)NSInteger(^rowCount)(UIPickerView *picView,NSInteger componentIndex);
@property(nonatomic,copy)UIView *(^cellData)(UIPickerView *picView,NSInteger row,NSInteger component,UIView *reusingView);
@end

@implementation KLPickerView

+ (instancetype)datePickWithMode:(UIDatePickerMode)datePickerMode
                     defaultDate:(NSDate *)defaultDate
                          cancle:(void(^)())cancle
                        doAtcion:(void(^)(id data))doAction {

    KLPickerView *view = [[KLPickerView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.cancleBlock = cancle;
    view.doBlock = doAction;
    view.pickerType = KLPickerTypeDatePikcer;
    [view createTopViews];

    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    datePicker.datePickerMode = datePickerMode;
    if (defaultDate) {

        datePicker.date = defaultDate;
    }

    [view addSubview:datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.lineView.mas_bottom);
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
    }];
    view.datePicker = datePicker;
    return view;
}

- (void)createTopViews {

    UIView *bar = [[UIView alloc] init];
    [self addSubview:bar];
    self.barView = bar;
    WEAKSELF;
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(@(40.5));
    }];


    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:colorWithStr(@"FFA819") forState:UIControlStateNormal];
    cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bar addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar.mas_top);
        make.left.equalTo(bar.mas_left).offset(15);
        make.bottom.equalTo(bar.mas_bottom);
        make.height.equalTo(bar.mas_height);
    }];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *doBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doBtn setTitleColor:colorWithStr(@"FFA819") forState:UIControlStateNormal];
    doBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [bar addSubview:doBtn];
    [doBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bar.mas_top);
        make.right.equalTo(bar.mas_right).offset(-15);
        make.bottom.equalTo(bar.mas_bottom);
        make.height.equalTo(bar.mas_height);
    }];
    [doBtn addTarget:self action:@selector(doBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorWithStr(@"D8D8D8");
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.height.equalTo(@(0.5));
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(bar.mas_bottom);
    }];
    self.lineView = lineView;
}

+ (instancetype)dataPikcerWithComponent:(NSInteger)component
                numberOfRowsInComponent:(NSInteger(^)(UIPickerView *picView,NSInteger componentIndex))numberOfRows
                               cellData:(UIView *(^)(UIPickerView *picView,NSInteger row,NSInteger component,UIView *reusingView))cellData
                                 cancle:(void(^)())cancle
                               doAtcion:(void(^)(id data))doAction {

    KLPickerView *view = [[KLPickerView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.component = component;
    view.cancleBlock = cancle;
    view.doBlock = doAction;
    view.rowCount = numberOfRows;
    view.pickerType = KLPickerTypeDataPikcer;
    view.cellData = cellData;
    [view createTopViews];

    UIPickerView *picker = [[UIPickerView alloc]init];
    picker.dataSource = view;
    picker.delegate = view;
    picker.showsSelectionIndicator = YES;
    [view addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.lineView.mas_bottom);
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
    }];
    view.picker = picker;
    [picker reloadAllComponents];
    return view;

}

#pragma mark UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return self.component;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return self.rowCount(pickerView,component);
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {

    return self.cellData(pickerView,row,component,view);

}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    return (kScreenW - 30 - 30*(self.component-1))/self.component;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    NSInteger nextComponent = component + 1 ;
    while (nextComponent <= pickerView.numberOfComponents -1) {

        [pickerView reloadComponent:nextComponent];
        [pickerView selectRow:0 inComponent:nextComponent animated:YES];
        nextComponent ++;
    }

}

#pragma mark other

- (void)cancleBtnClick:(UIButton *)btn {

    if (self.cancleBlock) {

        self.cancleBlock();
    }
}

- (void)doBtnClick:(UIButton *)btn {

    if (self.doBlock) {

        if (KLPickerTypeDatePikcer == self.pickerType) {
            self.doBlock(self.datePicker.date);

        } else {

            NSMutableArray *dataArryM = @[].mutableCopy;
            for (int i = 0; i < self.picker.numberOfComponents; i++) {

                [dataArryM addObject:@([self.picker selectedRowInComponent:i])];
            }
            self.doBlock(dataArryM);
        }

    }
}


@end
