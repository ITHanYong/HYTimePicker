//
//  HYDatePickerView.m
//  HYTimePicker
//
//  Created by HanYong on 2019/1/28.
//  Copyright © 2019 HanYong. All rights reserved.
//

#import "HYDatePickerView.h"
#define SCREENW     [UIScreen mainScreen].bounds.size.width

@interface HYDatePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *contentView;
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
}

@property (nonatomic, assign) NSString *startTime;
@property (nonatomic, assign) NSString *endTime;
@property (nonatomic, assign) NSInteger period;

@end

@implementation HYDatePickerView


- (instancetype)initDatePackerWithStartYear:(NSString *)startYear endYear:(NSString *)endYear period:(NSInteger)period selectedYear:(NSString *)selectedYear selectedMonth:(NSString *)selectedMonth{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    _startTime = startYear;
    _endTime = endYear;
    _period = period;
    _selectedYear = selectedYear;
    _selectedMonth = selectedMonth;
    
    [self initDataSource];
    [self initAppreaence:@[@"年",@"月"]];
    
    return self;
}

#pragma mark - initDataSource
- (void)initDataSource {
    
    [self configYearArray];
    [self configMonthArray];
    
    _selectedYear = _selectedYear ? _selectedYear : yearArray[0];
    _selectedMonth = _selectedMonth ? _selectedMonth : monthArray[0];
}

- (void)configYearArray {//配置小时数据源数组
    //初始化小时数据源数组
    yearArray = [[NSMutableArray alloc]init];
    
    NSString *startYear = [_startTime substringWithRange:NSMakeRange(0, 4)];
    NSString *endYear = [_endTime substringWithRange:NSMakeRange(0, 4)];
    
    for (NSInteger i = [startYear integerValue]; i <= [endYear integerValue]; i++) {//加小时数
        NSString *minStr = [NSString stringWithFormat:@"%ld",i];
        [yearArray addObject:minStr];
    }
}

- (void)configMonthArray {//配置分钟数据源数组
    monthArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *minStr = @"";
        if (i % _period == 0) {
            if (i < 10) {
                minStr = [NSString stringWithFormat:@"0%ld",(long)i];
            } else {
                minStr = [NSString stringWithFormat:@"%ld",(long)i];
            }
            [monthArray addObject:minStr];
        }
    }
}

#pragma mark - initAppreaence
- (void)initAppreaence:(NSArray *)labelArr{
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 260)];
    [self addSubview:contentView];
    //设置背景颜色为黑色，并有0.4的透明度
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 45)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 45)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:131/255.0 green:136/255.0 blue:154/255.0 alpha:1.00] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithRed:235/255.0 green:67/255.0 blue:57/255.0 alpha:1.00] forState:UIControlStateNormal];
        }
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择日期";
    titleLabel.textColor = [UIColor colorWithRed:43/255.0 green:49/255.0 blue:61/255.0 alpha:1.00];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.frame = CGRectMake(whiteView.center.x-50, 0, 100, 45);
    [whiteView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, 45-0.5, SCREENW, 0.5);
    line.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:241/255.0 alpha:1.00];
    [whiteView addSubview:line];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(self.bounds), 215)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.00];

    /*
     设置pickerView默认第一行 这里也可默认选中其他行 修改selectRow即可
     如果后台传过来的不是整点需要特殊处理
     */
    
    NSString *hour = [NSString stringWithFormat:@"%@",_selectedYear];
    NSString *minute = [NSString stringWithFormat:@"%@",_selectedMonth];
    
    [pickerView selectRow:[self monthIndex:hour month:minute] inComponent:1 animated:YES];
    [pickerView selectRow:[self yearIndex:hour month:minute] inComponent:0 animated:YES];
    
    [contentView addSubview:pickerView];
    
    for (int i = 0; i < 2; i++) {
        UILabel * label = [[UILabel alloc] init];
        if (i==0) {
            label.frame = CGRectMake(SCREENW/2 - 40, 215/2-15, 30, 30);
        }else{
            label.frame = CGRectMake(SCREENW/2 + 53, 215/2-15, 30, 30);
        }
        label.text = labelArr[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:131/255.0 green:136/255.0 blue:154/255.0 alpha:1.00];
        [pickerView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
    }
}

//获取小时的下标
-(NSInteger)yearIndex:(NSString *)hour month:(NSString *)month{
    
    //判断分钟是否大于分钟数组的最后一个元素值，如果大则小时+1分钟归0
    NSInteger hourAdd = [month integerValue] > [monthArray[monthArray.count-1] integerValue] ? 1 : 0;
    
    NSInteger index = [yearArray indexOfObject:hour] + hourAdd;
    index = index > yearArray.count-1 ? 0 : index;
    _selectedYear = yearArray[index];
    NSLog(@"hourIndex - %ld",(long)index);
    return index;
}

//获取分钟的下标
-(NSInteger)monthIndex:(NSString *)hour month:(NSString *)month{
    
    NSInteger index = 0;
    if ([monthArray containsObject:month]) {
        index = [monthArray indexOfObject:month];
    }else{
        if ([month integerValue] > [monthArray[monthArray.count-1] integerValue]) {
            index = 0;
        }else{
            for (NSInteger i=(monthArray.count-2); i<monthArray.count-1; i--) {
                
                if ([month integerValue] > [monthArray[i] integerValue]) {
                    index = i + 1;
                    _selectedMonth = monthArray[index];
                    NSLog(@"minIndex - %ld",(long)index);
                    return index;
                }
            }
        }
    }
    _selectedMonth = monthArray[index];
    NSLog(@"minIndex - %ld",(long)index);
    return index;
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        if ([self.delegate respondsToSelector:@selector(timePickerViewDidSelectYear:month:)]) {
            [self.delegate timePickerViewDidSelectYear:_selectedYear month:_selectedMonth];
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
        return yearArray.count;
    }
    else {
        return monthArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return yearArray[row];
    } else {
        return monthArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _selectedYear = yearArray[row];
    }else{
        _selectedMonth = monthArray[row];
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    [self changeSpearatorLineColor:pickerView];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW/2, 30)];
    
    //添加一个label
    UILabel * label = [[UILabel alloc] init];
    
    if (component == 0) {
        label.frame = CGRectMake(SCREENW/2-100, 0, 60, 30);
    }else{
        label.frame = CGRectMake(10, 0, 40, 30);
    }
    label.textColor = [UIColor colorWithRed:40/255.0 green:53/255.0 blue:76/255.0 alpha:1.00];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;

    if (component == 0){
        label.text = [NSString stringWithFormat:@"%@",yearArray[row]];
    }else{
        label.text = [NSString stringWithFormat:@"%@",monthArray[row]];
    }
    
    [bg addSubview:label];
    
    return bg;
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor:(UIPickerView *)pickerView {
    for(UIView *speartorView in pickerView.subviews) {
        if (speartorView.frame.size.height < 60 && ![speartorView isKindOfClass:[UILabel class]]) {//找出当前的 View
            // 添加分割线 (判断只添加一次  滑动不断刷新)
            if (speartorView.subviews.count ==0){
                UIView *line = [self lineView];
                line.frame = CGRectMake(0, 0, speartorView.frame.size.width, 0.5);
                [speartorView addSubview:line];
                
                UIView *line2 = [self lineView];
                line2.frame = CGRectMake(0, speartorView.frame.size.height-1, speartorView.frame.size.width, 0.5);
                [speartorView addSubview:line2];
            }
 
            speartorView.backgroundColor = [UIColor clearColor];
        }else{
            speartorView.backgroundColor = [UIColor clearColor];
        }
    }
}
/// 分割线
- (UIView *)lineView {
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:241/255.0 alpha:1.00];
    return line;
}

@end
