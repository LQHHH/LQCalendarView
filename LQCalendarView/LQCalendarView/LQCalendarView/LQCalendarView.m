//
//  LQCalendarView.m
//  LQCalendarView
//
//  Created by hhh on 2018/9/22.
//  Copyright © 2018年 LQ. All rights reserved.
//

#import "LQCalendarView.h"
#import "LQCalendarCollectionViewCell.h"
#import "LQCalendarManager.h"

@interface LQCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *currentMonth;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *advanceButton;
@property (nonatomic, strong) LQCalendarManager *manager;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSMutableArray *weaks;

@end

@implementation LQCalendarView
@synthesize selecterDate = _selecterDate;

- (void)setFrame:(CGRect)frame {
    if (CGRectIsEmpty(frame)) {
        return;
    }
    CGRect newFrame = frame;
    if (newFrame.size.height < 240) {
        newFrame.size.height = 240;
    }
    [super setFrame:newFrame];
    [self initData];
}

- (void)initData {
    self.backgroundColor = self.tintColor?:[UIColor colorWithRed:85/255.0 green:193/255.0 blue:247/255.0 alpha:1];
    self.count = 1;
    NSDate *showDate =  self.selecterDate?:[NSDate date];
    [self.dates addObjectsFromArray:@[[self.manager getOtherDateFromDate:showDate Month:-1],
                                      showDate,
                                      [self.manager getOtherDateFromDate:showDate Month:1]]];
    self.currentMonth.text = [self.manager currentDateStringWith:self.dates[self.count]];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.advanceButton setImage:[UIImage imageNamed:@"advance"] forState:UIControlStateNormal];
    [self createWeakButton];
    [self collectionView];
}

- (void)setSelecterDate:(NSDate *)selecterDate {
    _selecterDate = selecterDate;
    if (self.dates.count == 0) {
        return;
    }
    [self.dates removeAllObjects];
    NSDate *showDate = selecterDate?:[NSDate date];
    [self.dates addObjectsFromArray:@[[self.manager getOtherDateFromDate:showDate Month:-1],
                                      showDate,
                                      [self.manager getOtherDateFromDate:showDate Month:1]]];
    self.currentMonth.text = [self.manager currentDateStringWith:self.dates[self.count]];
    [self.collectionView reloadData];
}

- (NSDate *)selecterDate {
    if (!_selecterDate) {
        return [NSDate date];
    }
    return _selecterDate;
}


- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    if (self.weaks.count == 0) {
        return;
    }
    self.backgroundColor = tintColor;
    for (UIButton *button in self.weaks) {
        [button setBackgroundColor:tintColor];
    }
    [self.collectionView reloadData];
}

#pragma mark - click

- (void)clickBack:(UIButton *)sender {
    [self.collectionView setContentOffset:CGPointMake(0, 0)
                                 animated:YES];
}

- (void)clickAdvance:(UIButton *)sender {
    [self.collectionView setContentOffset:CGPointMake(2*self.bounds.size.width, 0)
                                 animated:YES];
}


#pragma mark - create weak

- (void)createWeakButton {
    NSArray *array = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat width = self.bounds.size.width/array.count;
    for (int i =0; i < array.count; i++) {
        UIButton *button = [UIButton new];
        [button setBackgroundColor:self.tintColor?:[UIColor colorWithRed:85/255.0
                                                                   green:193/255.0
                                                                    blue:247/255.0
                                                                   alpha:1]];
        [button setFrame:CGRectMake(width*i, 37, width, 20)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.1 alpha:0.5] forState:UIControlStateNormal];
        if (i == 0 || i == 6) {
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:button];
        [self.weaks addObject:button];
    }
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseString = @"calendarCollectionViewCell";
    LQCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseString forIndexPath:indexPath];
    cell.date = self.dates[indexPath.row];
    cell.selecterDay = self.selecterDate;
    cell.backgroundColor = self.tintColor?:[UIColor colorWithRed:85/255.0 green:193/255.0 blue:247/255.0 alpha:1];
    __weak typeof(self)wself = self;
    [cell setBlock:^(NSDate *date) {
        wself.selecterDate = date;
        if (wself.block) {
            wself.block(date);
        }
    }];
    return cell;
    
}

#pragma mark -UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width,self.bounds.size.height - 60);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x_offset = scrollView.contentOffset.x;
    if (x_offset == 2*self.bounds.size.width) {
        self.collectionView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        self.count ++;
    }
    if (x_offset == 0) {
        self.collectionView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        self.count --;
    }
    if (self.count != 1) {
        [self reloadDada];
    }
}

- (void)reloadDada {
    NSDate *currentDate = self.dates[self.count];
    [self.dates removeAllObjects];
    [self.dates addObjectsFromArray:@[[self.manager getOtherDateFromDate:currentDate Month:-1],
                                      currentDate,
                                      [self.manager getOtherDateFromDate:currentDate Month:1]]];
    self.count = 1;
    self.currentMonth.text = [self.manager currentDateStringWith:self.dates[1]];
    [self.collectionView reloadData];
}

#pragma mark - lazy

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        _backButton.frame = CGRectMake(10, 5, 25, 25);
        [_backButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
    }
    return _backButton;
}

- (UIButton *)advanceButton {
    if (!_advanceButton) {
        _advanceButton = [[UIButton alloc] init];
        _advanceButton.frame = CGRectMake(self.bounds.size.width - 35, 5, 25, 25);
        [_advanceButton addTarget:self action:@selector(clickAdvance:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_advanceButton];
        
    }
    return _advanceButton;
}

- (UILabel *)currentMonth {
    if (!_currentMonth) {
        _currentMonth = [UILabel new];
        _currentMonth.frame = CGRectMake(0, 10, self.bounds.size.width, 20);
        _currentMonth.textColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        _currentMonth.textAlignment = NSTextAlignmentCenter;
        _currentMonth.font = [UIFont systemFontOfSize:13];
        [self addSubview:_currentMonth];
    }
    return _currentMonth;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, self.bounds.size.width, self.bounds.size.height - 60) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        [_collectionView registerClass:[LQCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"calendarCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (LQCalendarManager *)manager {
    if (!_manager) {
        _manager = [[LQCalendarManager alloc] init];
    }
    return _manager;
}

- (NSMutableArray *)dates {
    if (!_dates) {
        _dates = @[].mutableCopy;
    }
    return _dates;
}

- (NSMutableArray *)weaks {
    if (!_weaks) {
        _weaks = @[].mutableCopy;
    }
    return _weaks;
}

@end

