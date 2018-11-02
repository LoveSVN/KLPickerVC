//
//  ViewController.m
//  demo
//
//  Created by 张晓亮 on 2018/11/2.
//  Copyright © 2018 张晓亮. All rights reserved.
//

#import "ViewController.h"
#import "KLPickerVC.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *shengshiBtn;
@property (weak, nonatomic) IBOutlet UILabel *displayLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)dateBtnClick:(UIButton *)sender {

    KLPickerVC *vc = [[KLPickerVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    WEAKSELF;
    [self presentViewController:vc animated:NO completion:^{

        [vc showDatePickerWithDefaultDate:nil cancle:^{

        } doAtcion:^(id  _Nonnull data) {
            NSDate *date = data;
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"YYYY-MM-dd";
            NSString *dateStr = [formatter stringFromDate:date ];

            weakSelf.displayLable.text = dateStr;
            NSLog(@"%@===",data);
        }];
    }];

}


- (IBAction)shengshiBtn:(UIButton *)sender {



    KLPickerVC *vc = [[KLPickerVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    WEAKSELF;

    [self presentViewController:vc animated:NO completion:^{

        [vc showAddressPickerViewWithCancle:^{

        } doAtcion:^(id  _Nonnull data) {

            //                    NSLog(@"%@===",data);
            NSArray *dataArry = data;
            NSString *str = [NSString stringWithFormat:@"%@%@",dataArry.firstObject,dataArry.lastObject];
            weakSelf.displayLable.text = str;
        }];
    }];
}


@end
