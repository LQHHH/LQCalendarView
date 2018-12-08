//
//  ViewController.m
//  LQCalendarView
//
//  Created by hhh on 2018/9/22.
//  Copyright © 2018年 LQ. All rights reserved.
//

#import "ViewController.h"
#import "LQCalendarView.h"
@interface ViewController ()

@property (nonatomic, strong) LQCalendarView *calendarView;
@property (nonatomic, strong) UILabel *seleterDateL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self calendarView];
    self.seleterDateL.text = [self dateString];
}

#pragma mark - lazy

- (LQCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[LQCalendarView alloc] init];
        _calendarView.frame = CGRectMake(50, 200, self.view.frame.size.width - 100,240);
        _calendarView.tintColor = [UIColor whiteColor];
        [self.view addSubview:_calendarView];
        __weak typeof(self)wself = self;
        [_calendarView setBlock:^(NSDate *date) {
            wself.seleterDateL.text = [wself dateString];
        }];
    }
    return _calendarView;
}

- (UILabel *)seleterDateL {
    if (!_seleterDateL) {
        _seleterDateL = [UILabel new];
        _seleterDateL.frame = CGRectMake(self.view.bounds.size.width/2-150, 100, 300, 50);
        _seleterDateL.textColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        _seleterDateL.textAlignment = NSTextAlignmentCenter;
        _seleterDateL.font = [UIFont systemFontOfSize:20];
        [self.view addSubview:_seleterDateL];
    }
    return _seleterDateL;
}

- (NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [dateFormatter stringFromDate:self.calendarView.selecterDate];
    return string;
}

@end
