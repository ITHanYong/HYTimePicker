//
//  ViewController.m
//  HYTimePicker
//
//  Created by HanYong on 2019/1/28.
//  Copyright © 2019 HanYong. All rights reserved.
//

#import "ViewController.h"
#import "HYTimePickerView.h"
#import "HYDatePickerView.h"

@interface ViewController ()<TimePickerViewDelegate,DatePickerViewDelegate>
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, copy) NSString *selectedYear;

@property (nonatomic, copy) NSString *selectedMonth;

@property (nonatomic, copy) NSString *selectedHour;

@property (nonatomic, copy) NSString *selectedMinter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, 50, 30);
    [btn setTitle:@"时分" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 100, 30)];
    [self.view addSubview:self.timeLabel];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(140, 100, 50, 30);
    [btn1 setTitle:@"年月" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn1];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 60, 100, 30)];
    [self.view addSubview:self.dateLabel];
}

-(void)btnClick{
    
    HYTimePickerView *picker = [[HYTimePickerView alloc] initDatePackerWithStartHour:@"00" endHour:@"24" period:15 selectedHour:self.selectedHour ?: @"08" selectedMin:self.selectedMinter ?: @"13"];
    picker.delegate = self;
    [picker show];
}

-(void)btnClick1{
    
    HYDatePickerView *picker1 = [[HYDatePickerView alloc] initDatePackerWithStartYear:@"2015" endYear:@"2021" period:1 selectedYear:self.selectedYear ?: @"2020" selectedMonth:self.selectedMonth ?: @"09"];
    picker1.delegate = self;
    [picker1 show];
}

#pragma mark - TimePickerViewDelegate
-(void)timePickerViewDidSelectHour:(NSString *)hour minute:(NSString *)minute{
    self.selectedHour = hour;
    self.selectedMinter = minute;
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",hour,minute];
}

#pragma mark - DatePickerViewDelegate
-(void)timePickerViewDidSelectYear:(NSString *)year month:(NSString *)month{
    self.selectedYear = year;
    self.selectedMonth = month;
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",year,month];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
