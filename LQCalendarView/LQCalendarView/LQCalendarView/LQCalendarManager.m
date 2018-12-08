//
//  LQCalendarManager.m
//  LQCalendarView
//
//  Created by hhh on 2018/12/3.
//  Copyright © 2018 LQ. All rights reserved.
//

#import "LQCalendarManager.h"

@implementation LQCalendarManager

- (NSString *)currentDateStringWith:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    return [NSString stringWithFormat:@"%04ld-%02ld",dateComponents.year,dateComponents.month];
}

- (NSUInteger)currentDayWithDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitDay fromDate:date];
    return dateComponents.day;
}

- (BOOL)isSameDate:(NSDate *)date
         otherDate:(NSDate *)otherDate {
    NSDateComponents *dateComponents = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSDateComponents *dateComponents1 = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:otherDate];
    
    return  [dateComponents month] == [dateComponents1 month] &&
            [dateComponents year]  == [dateComponents1 year];
}

- (NSInteger )currentDateFirstDayInWeakWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [dateComponents setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:dateComponents];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)currentDateTotalDayWithDate:(NSDate *)date {
    NSRange daysInOfMonth = [[NSCalendar autoupdatingCurrentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

- (NSDate *)getOtherDateFromDate:(NSDate*)date
                           Month:(NSInteger)month {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:month];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    return [calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)selecterDateFromDate:(NSDate*)date
                           day:(NSInteger)day {
     NSDateComponents *dateComponents = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
     dateComponents.day = day;
    return [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:dateComponents];
}

@end
