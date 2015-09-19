//
//  YCDatePicker.h
//  YCDatePicker
//
//  Created by 超杨 on 15/9/19.
//  Copyright (c) 2015年 超杨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCDatePicker : UIView
/** 时间选择器类型 */
@property (nonatomic, assign) UIDatePickerMode mode;
/** label显示格式字符串 */
@property (nonatomic, copy) NSString *LabelFormatString;

/** 选择结束block */
@property (nonatomic, copy) void(^completionBlock)(NSDate * date);

/** 显示 */
- (void)showWithAnimated:(BOOL)animated;

/** 工厂方法 */
+ (instancetype)YCDatePicker;
+ (instancetype)YCDatePickerWithValueChangeCompletionBlock:(void(^)(NSDate * date))completion;
@end
