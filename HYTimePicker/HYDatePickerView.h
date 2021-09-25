//
//  HYDatePickerView.h
//  HYTimePicker
//
//  Created by HanYong on 2019/1/28.
//  Copyright © 2019 HanYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate<NSObject>
@optional

//通过协议将选中的时间返回
-(void)timePickerViewDidSelectYear:(NSString *)year month:(NSString *)month;

@end

@interface HYDatePickerView : UIView

@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;

@property (nonatomic, copy) NSString *selectedYear;

@property (nonatomic, copy) NSString *selectedMonth;

/**
 初始化方法
 
 @param startYear 起始时间点 时
 @param endYear 结束时间点 时
 @param period 间隔多少分中
 @return QFTimePickerView实例
 */
- (instancetype)initDatePackerWithStartYear:(NSString *)startYear endYear:(NSString *)endYear period:(NSInteger)period selectedYear:(NSString *)selectedYear selectedMonth:(NSString *)selectedMonth;

- (void)show;

@end
