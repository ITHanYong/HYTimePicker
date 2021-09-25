//
//  HYTimePickerView.h
//  HYTimePicker
//
//  Created by HanYong on 2019/1/28.
//  Copyright © 2019 HanYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimePickerViewDelegate<NSObject>
@optional

//通过协议将选中的时间返回
-(void)timePickerViewDidSelectHour:(NSString *)hour minute:(NSString *)minute;

@end

@interface HYTimePickerView : UIView

@property (nonatomic, weak) id<TimePickerViewDelegate> delegate;

@property (nonatomic, copy) NSString *selectedHour;

@property (nonatomic, copy) NSString *selectedMin;

/**
 初始化方法
 
 @param startHour 其实时间点 时
 @param endHour 结束时间点 时
 @param period 间隔多少分中
 @return QFTimePickerView实例
 */
- (instancetype)initDatePackerWithStartHour:(NSString *)startHour endHour:(NSString *)endHour period:(NSInteger)period selectedHour:(NSString *)selectedHour selectedMin:(NSString *)selectedMin;

- (void)show;

@end
