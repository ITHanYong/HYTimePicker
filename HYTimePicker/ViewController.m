//
//  ViewController.m
//  HYTimePicker
//
//  Created by HanYong on 2019/1/28.
//  Copyright © 2019 HanYong. All rights reserved.
//

#import "ViewController.h"
#import "HYTimePickerView.h"

@interface ViewController ()<TimePickerViewDelegate>
@property (nonatomic, strong) UILabel *label;
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
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 250, 30)];
    [self.view addSubview:self.label];
}

-(void)btnClick{
    
    HYTimePickerView *picker = [[HYTimePickerView alloc] initDatePackerWithStartHour:@"00" endHour:@"24" period:15 selectedHour:@"08" selectedMin:@"13"];
    picker.delegate = self;
    [picker show];
}

-(void)timePickerViewDidSelectRow:(NSString *)time{
    
    self.label.text = time;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
