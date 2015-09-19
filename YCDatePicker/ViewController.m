//
//  ViewController.m
//  YCDatePicker
//
//  Created by 超杨 on 15/9/19.
//  Copyright (c) 2015年 超杨. All rights reserved.
//

#import "ViewController.h"
#import "YCDatePicker.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *styleSeg;

@end

@implementation ViewController

- (IBAction)showBtnClick:(UIButton *)sender {
    YCDatePicker *picker = [YCDatePicker YCDatePickerWithValueChangeCompletionBlock:^(NSDate *date) {
        
        NSDate *select = date; // 获取被选中的时间
        NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
        if (self.styleSeg.selectedSegmentIndex) {
            
            selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
        } else {
            selectDateFormatter.dateFormat = @"a hh:mm"; // 设置时间和日期的格式
        }
        NSString *text = [selectDateFormatter stringFromDate:select];
        self.dateLable.text = text;
    }];
    UIDatePickerMode mode = self.styleSeg.selectedSegmentIndex ? UIDatePickerModeDate: UIDatePickerModeTime;
    
    
    picker.mode = mode;
    picker.LabelFormatString = self.styleSeg.selectedSegmentIndex ? @"yyyy年MM月dd日 EEEE": nil;
    [picker showWithAnimated:YES];

}



@end
