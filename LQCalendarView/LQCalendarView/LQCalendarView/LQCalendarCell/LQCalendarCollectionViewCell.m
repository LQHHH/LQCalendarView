//
//  LQCalendarCollectionViewCell.m
//  LQCalendarView
//
//  Created by hhh on 2018/9/22.
//  Copyright © 2018年 LQ. All rights reserved.
//

#import "LQCalendarCollectionViewCell.h"
#import "LQCalendarManager.h"

@interface LQCalendarCollectionViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LQCalendarManager *manager;
@property (nonatomic, assign) NSInteger firstDay;
@property (nonatomic, assign) NSInteger line;
@property (nonatomic, assign) NSInteger totalDayCount;
@property (nonatomic, assign) BOOL isCurrentMonth;
@property (nonatomic, strong) NSIndexPath *lastSelecterIndex;

@end

@implementation LQCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    self.firstDay = [self.manager currentDateFirstDayInWeakWithDate:date];
    self.totalDayCount = [self.manager currentDateTotalDayWithDate:date];
    self.line = (self.totalDayCount-(7-self.firstDay))%7>0?(self.totalDayCount-(7-self.firstDay))/7 +2:(self.totalDayCount-(7-self.firstDay))/7+1;
    self.isCurrentMonth = [self.manager isSameDate:date otherDate:[NSDate date]];
    [self.collectionView reloadData];
    
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.line*7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseString = @"dayCollectionViewCell";
    LQDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseString forIndexPath:indexPath];
    cell.title = @"";
    cell.titleColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    cell.bgColor = [UIColor clearColor];
    if (indexPath.item >= self.firstDay && indexPath.item <= self.totalDayCount+self.firstDay-1) {
         cell.title = @(indexPath.item - self.firstDay+1).stringValue;
    }
    if ([self.manager isSameDate:self.date otherDate:self.selecterDay] &&
        indexPath.item == [self.manager currentDayWithDate:self.selecterDay]+self.firstDay-1) {
        cell.titleColor = [UIColor whiteColor];
        cell.bgColor = [UIColor orangeColor];
        self.lastSelecterIndex = indexPath;
    }
    if (self.isCurrentMonth && indexPath.item == [self.manager currentDayWithDate:[NSDate date]]+self.firstDay-1) {
        cell.titleColor = [UIColor whiteColor];
        cell.bgColor = [UIColor redColor];
    }
    cell.backgroundColor = self.backgroundColor;
    return cell;
    
}

#pragma mark -UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"我的bounds是：%@-----%ld",NSStringFromCGSize(CGSizeMake(self.bounds.size.width/7,self.bounds.size.height/self.line)),self.line);
    return CGSizeMake(self.bounds.size.width/7,self.bounds.size.height/self.line);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastSelecterIndex && self.lastSelecterIndex.item !=  [self.manager currentDayWithDate:[NSDate date]]+self.firstDay-1) {
        LQDayCollectionViewCell *lastcCell = (LQDayCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.lastSelecterIndex];
        lastcCell.titleColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        lastcCell.bgColor = [UIColor clearColor];
    }
    self.lastSelecterIndex = indexPath;
    LQDayCollectionViewCell *cell = (LQDayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleColor = [UIColor whiteColor];
    cell.bgColor = [UIColor orangeColor];
    if (self.isCurrentMonth && indexPath.item == [self.manager currentDayWithDate:[NSDate date]]+self.firstDay-1) {
        cell.titleColor = [UIColor whiteColor];
        cell.bgColor = [UIColor redColor];
    }
    if (self.block) {
        self.block([self.manager selecterDateFromDate:self.date day:indexPath.row-self.firstDay+1]);
    }
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[LQDayCollectionViewCell class] forCellWithReuseIdentifier:@"dayCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (LQCalendarManager *)manager {
    if (!_manager) {
        _manager = [[LQCalendarManager alloc] init];
    }
    return _manager;
}

@end

@interface LQDayCollectionViewCell ()

@property (nonatomic, strong) UILabel *day;

@end

@implementation LQDayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.day.textColor = titleColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.day.text = title;
    self.day.frame = CGRectMake(self.bounds.size.width/2-10,
                                self.bounds.size.height/2-10,
                                20, 20);
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.day.backgroundColor = bgColor;
}

#pragma mark - lazy

- (UILabel *)day {
    if (!_day) {
        _day = [UILabel new];
        _day.frame = CGRectMake(self.bounds.size.width/2-10,
                                self.bounds.size.height/2-10,
                                20, 20);
        _day.layer.cornerRadius = 10;
        _day.layer.masksToBounds = YES;
        _day.textColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        _day.textAlignment = NSTextAlignmentCenter;
        _day.font = [UIFont systemFontOfSize:13];
        [self addSubview:_day];
    }
    return _day;
}

@end
