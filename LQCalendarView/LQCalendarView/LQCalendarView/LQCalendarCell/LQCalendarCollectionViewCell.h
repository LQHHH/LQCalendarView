//
//  LQCalendarCollectionViewCell.h
//  LQCalendarView
//
//  Created by hhh on 2018/9/22.
//  Copyright © 2018年 LQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSDate *date);

@interface LQCalendarCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)NSDate *selecterDay;
@property (nonatomic, copy)selectBlock block;

@end

@interface LQDayCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *bgColor;

@end
