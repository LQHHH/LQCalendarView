//
//  LQCalendarView.h
//  LQCalendarView
//
//  Created by hhh on 2018/9/22.
//  Copyright © 2018年 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSDate *date);

@interface LQCalendarView : UIView

//选中的日期，接受传入上次选中的日期
@property (nonatomic, strong)NSDate *selecterDate;
//设置当前的主题色
@property (nonatomic, strong)UIColor *tintColor;
//选择日期后的回调
@property (nonatomic, copy)selectBlock block;

@end

