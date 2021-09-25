//
//  HYTimePickerView.m
//  HYTimePicker
//
//  Created by HanYong on 2019/1/28.
//  Copyright © 2019 HanYong. All rights reserved.
//

#import "HYTimePickerView.h"
#define SCREENW     [UIScreen mainScreen].bounds.size.width

@interface HYTimePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *contentView;
    
    NSMutableArray *hourArray;
    NSMutableArray *minArray;
}

@property (nonatomic, assign) NSString *startTime;
@property (nonatomic, assign) NSString *endTime;
@property (nonatomic, assign) NSInteger period;

@end

@implementation HYTimePickerView

/**
 初始化方法
 
 @param startHour 其实时间点 时
 @param endHour 结束时间点 时
 @param period 间隔多少分中
 @return QFTimePickerView实例
 */
- (instancetype)initDatePackerWithStartHour:(NSString *)startHour endHour:(NSString *)endHour period:(NSInteger)period selectedHour:(NSString *)selectedHour selectedMin:(NSString *)selectedMin{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    _startTime = startHour;
    _endTime = endHour;
    _period = period;
    _selectedHour = selectedHour;
    _selectedMin = selectedMin;
    
    [self initDataSource];
    [self initAppreaence];
    
    return self;
}

#pragma mark - initDataSource
- (void)initDataSource {
    
    [self configHourArray];
    [self configMinArray];
    
    _selectedHour = _selectedHour ? _selectedHour : hourArray[0];
    _selectedMin = _selectedMin ? _selectedMin : minArray[0];
}

- (void)configHourArray {//配置小时数据源数组
    //初始化小时数据源数组
    hourArray = [[NSMutableArray alloc]init];
    
    NSString *startHour = [_startTime substringWithRange:NSMakeRange(0, 2)];
    NSString *endHour = [_endTime substringWithRange:NSMakeRange(0, 2)];
    
    if ([startHour integerValue] > [endHour integerValue]) {//跨天
        NSString *minStr = @"";
        for (NSInteger i = [startHour integerValue]; i < 24; i++) {//加当天的小时数
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",i];
            }
            [hourArray addObject:minStr];
        }
        for (NSInteger i = 0; i <= [endHour integerValue]; i++) {//加次天的小时数
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",i];
            }
            [hourArray addObject:minStr];
        }
    } else {
        for (NSInteger i = [startHour integerValue]; i < [endHour integerValue]; i++) {//加小时数
            NSString *minStr = @"";
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",i];
            }
            [hourArray addObject:minStr];
        }
    }
}

- (void)configMinArray {//配置分钟数据源数组
    minArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 60; i++) {
        NSString *minStr = @"";
        if (i % _period == 0) {
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",(long)i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",(long)i];
            }
            [minArray addObject:minStr];
        }
    }
    [minArray insertObject:@"00" atIndex:0];
    [minArray removeLastObject];
}

#pragma mark - initAppreaence
- (void)initAppreaence {
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
    [self addSubview:contentView];
    //设置背景颜色为黑色，并有0.4的透明度
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 40)];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:97.0 / 255.0 green:97.0 / 255.0 blue:97.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    
    /*
     设置pickerView默认第一行 这里也可默认选中其他行 修改selectRow即可
     如果后台传过来的不是整点需要特殊处理
     */
    
    NSString *hour = [NSString stringWithFormat:@"%@",_selectedHour];
    NSString *minute = [NSString stringWithFormat:@"%@",_selectedMin];
    
    [pickerView selectRow:[self minuteIndex:hour minute:minute] inComponent:1 animated:YES];
    [pickerView selectRow:[self hourIndex:hour minute:minute] inComponent:0 animated:YES];
    
    
    [contentView addSubview:pickerView];
    
    //在时间选择器上 - 时分
    NSArray * labelArr = @[@"时",@"分"];
    for (int i = 0; i < 2; i++) {
        UILabel * label = [[UILabel alloc] init];
        if (i==0) {
            label.frame = CGRectMake(SCREENW/2 - 40, 260/2-15, 30, 30);
        }else{
            label.frame = CGRectMake(SCREENW/2 + 53, 260/2-15, 30, 30);
        }
        label.text = labelArr[i];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor blackColor];
        [pickerView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        //label.backgroundColor = [UIColor orangeColor];
    }
}

//获取小时的下标
-(NSInteger)hourIndex:(NSString *)hour minute:(NSString *)minute{
    
    //判断分钟是否大于分钟数组的最后一个元素值，如果大则小时+1分钟归0
    NSInteger hourAdd = [minute integerValue] > [minArray[minArray.count-1] integerValue] ? 1 : 0;
    
    NSInteger index = [hourArray indexOfObject:hour] + hourAdd;
    index = index > hourArray.count-1 ? 0 : index;
    _selectedHour = hourArray[index];
    NSLog(@"hourIndex - %ld",(long)index);
    return index;
}

//获取分钟的下标
-(NSInteger)minuteIndex:(NSString *)hour minute:(NSString *)minute{
    
    NSInteger index = 0;
    if ([minArray containsObject:minute]) {
        index = [minArray indexOfObject:minute];
    }else{
        
        if ([minute integerValue] > [minArray[minArray.count-1] integerValue]) {
            index = 0;
        }else{
            for (NSInteger i=(minArray.count-2); i<minArray.count-1; i--) {
                
                if ([minute integerValue] > [minArray[i] integerValue]) {
                    index = i + 1;
                    _selectedMin = minArray[index];
                    NSLog(@"minIndex - %ld",(long)index);
                    return index;
                }
            }
        }
    }
    _selectedMin = minArray[index];
    NSLog(@"minIndex - %ld",(long)index);
    return index;
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        if ([self.delegate respondsToSelector:@selector(timePickerViewDidSelectHour:minute:)]) {
            [self.delegate timePickerViewDidSelectHour:_selectedHour minute:_selectedMin];
        }
        [self dismiss];
    }
}

#pragma mark - pickerView出现
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}

#pragma mark - pickerView消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return hourArray.count;
    }
    else {
        return minArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return hourArray[row];
    } else {
        return minArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _selectedHour = hourArray[row];
        
        if ([_selectedHour isEqualToString:[hourArray lastObject]]) {
            [pickerView selectRow:0 inComponent:1 animated:YES];
            _selectedMin = @"00";
        }
        [pickerView reloadComponent:1];
        
    } else {
        _selectedMin = minArray[row];
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW/2, 30)];
    
    //添加一个label
    UILabel * label = [[UILabel alloc] init];
    
    if (component == 0) {
        label.frame = CGRectMake(SCREENW/2-80, 0, 40, 30);
    }else{
        label.frame = CGRectMake(10, 0, 40, 30);
    }
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    //label.backgroundColor = [UIColor redColor];
    if (component == 0){
        label.text = [NSString stringWithFormat:@"%@",hourArray[row]];
    }else{
        label.text = [NSString stringWithFormat:@"%@",minArray[row]];
    }
    
    [bg addSubview:label];
    
    return bg;
}


@end
