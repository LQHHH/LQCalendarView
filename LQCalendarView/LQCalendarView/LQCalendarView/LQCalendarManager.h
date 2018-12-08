//
//  LQCalendarManager.h
//  LQCalendarView
//
//  Created by hhh on 2018/12/3.
//  Copyright © 2018 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LQCalendarManager : NSObject

/*
 返回当前的时间,格式xxxx-xx
 */
- (NSString *)currentDateStringWith:(NSDate *)date;

/*
 返回day
 */
- (NSUInteger)currentDayWithDate:(NSDate *)date;

/*
 是否是同一月
 */
- (BOOL)isSameDate:(NSDate *)date
         otherDate:(NSDate *)otherDate;

/*
 返回当月的第一天是周几
 */
- (NSInteger)currentDateFirstDayInWeakWithDate:(NSDate *)date;

/*
 返回当月一共有多少天
 */
- (NSInteger)currentDateTotalDayWithDate:(NSDate *)date;

/*
 获取相对于date来说的前几个月或者后几个月的date
*/

- (NSDate *)getOtherDateFromDate:(NSDate*)date
                           Month:(NSInteger)month;

/*
 组成选中的时间
 */

- (NSDate *)selecterDateFromDate:(NSDate*)date
                           day:(NSInteger)day;

@end

