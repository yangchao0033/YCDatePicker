//
//  YCDatePicker.m
//  YCDatePicker
//
//  Created by 超杨 on 15/9/19.
//  Copyright (c) 2015年 超杨. All rights reserved.
//

#import "YCDatePicker.h"
#import "UIView+Frame.h"

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)          //界面高
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)           //界面宽
@interface YCDatePicker ()
/** 蒙版view */
@property (nonatomic, strong) UIView *bgView;
/** 选择器 */
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
/** 日期显示lable */
@property (weak, nonatomic) IBOutlet UILabel *dateTitle;
/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, assign) BOOL animated;

@end

@implementation YCDatePicker

- (void)awakeFromNib
{
    /** 设置取消 */
    self.cancelBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    if (iPhone5) {
        self.dateTitle.font = [UIFont systemFontOfSize:18];
    }
    
    /** 设置是否实现动画 */
    self.animated = NO;
}

- (void)showWithAnimated:(BOOL)animated
{
    
    self.animated = animated;
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [KEY_WINDOW addSubview:self.bgView];
    
    /** 防止循环引用 */
    __weak typeof(self) weakSelf = self;
    weakSelf.width = SCREEN_WIDTH * 0.8;
    weakSelf.height = SCREEN_HEIGHT * 0.4;
    weakSelf.centerX = SCREEN_WIDTH / 2;
    weakSelf.centerY = SCREEN_HEIGHT / 2;
    weakSelf.dataPicker.datePickerMode = self.mode;
    
    [self.bgView addSubview:weakSelf];
    
    if (animated) {
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        weakSelf.alpha = 0;
        CGAffineTransform orginTransform = weakSelf.transform;
        weakSelf.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.alpha = 1;
            weakSelf.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            weakSelf.transform = CGAffineTransformScale(orginTransform, 1, 1);
        } completion:^(BOOL finished) {
            /** 注销所有键盘 */
            [KEY_WINDOW endEditing:YES];
        }];
    } else {
        /** 注销所有键盘 */
        [KEY_WINDOW endEditing:YES];        
    }
}
- (void)dismiss
{
    /** 防止循环引用 */
    CGAffineTransform orginTransform = self.transform;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.transform = CGAffineTransformScale(orginTransform, 0.1, 0.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.bgView removeFromSuperview];
            self.bgView = nil;
        }
    }];
    
    if (self.completionBlock) {
        self.completionBlock(self.dataPicker.date);
    }
}


+ (instancetype)YCDatePicker
{
    YCDatePicker *pickerView = [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
    pickerView.layer.borderColor = [UIColor colorWithRed:188/255.0 green:186/255.0 blue:193/255.0 alpha:1.0].CGColor;
    pickerView.layer.borderWidth = 0.5;
    pickerView.layer.cornerRadius = pickerView.width * 0.05;
    
    NSDate *select = [pickerView.dataPicker date]; // 获取被选中的时间
    
    // label显示格式
    NSDateFormatter *selectDateFormatter1 = [[NSDateFormatter alloc] init];
    selectDateFormatter1.dateFormat = @"a hh:mm"; // 设置时间和日期的格式
    NSString *dateToLable = [selectDateFormatter1 stringFromDate:select];
    pickerView.dateTitle.text = dateToLable;
    
    
    return pickerView;
}

+ (instancetype)YCDatePickerWithValueChangeCompletionBlock:(void(^)(NSDate * date))completion
{
    YCDatePicker *pickerView = [self YCDatePicker];
    pickerView.completionBlock = completion;
    return pickerView;
}

#pragma mark - 实现oneDatePicker的监听方法
- (IBAction)oneDatePickerValueChanged:(UIDatePicker *) sender {
    
    NSDate *select = [sender date]; // 获取被选中的时间
    
    // label显示格式
    NSDateFormatter *selectDateFormatter1 = [[NSDateFormatter alloc] init];
    selectDateFormatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    selectDateFormatter1.dateFormat = self.LabelFormatString; // 设置时间和日期的格式
    NSString *dateToLable = [selectDateFormatter1 stringFromDate:select];
    self.dateTitle.text = dateToLable;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.dateTitle.transform = CGAffineTransformMakeScale(1.6, 1.6);
        self.dateTitle.alpha = 0.4;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.dateTitle.transform = CGAffineTransformMakeScale(1, 1);
            self.dateTitle.alpha = 1;
        }];
    }];
    
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    self.completionBlock = nil;
    [self dismiss];
}

- (void)setLabelFormatString:(NSString *)LabelFormatString
{
    if (LabelFormatString == nil) {
        _LabelFormatString = [@"a hh:mm" copy];
    } else {
        _LabelFormatString = [LabelFormatString copy];
    }
    // label显示格式
    NSDateFormatter *selectDateFormatter1 = [[NSDateFormatter alloc] init];
    selectDateFormatter1.dateFormat = _LabelFormatString; // 设置时间和日期的格式
    NSString *dateToLable = [selectDateFormatter1 stringFromDate:self.dataPicker.date];
    self.dateTitle.text = dateToLable;
}
//- (NSString *)LabelFormatString
//{
//    if (_LabelFormatString == nil) {
//        _LabelFormatString = @"a hh:mm";
//    }
//    return _LabelFormatString;
//}
@end
