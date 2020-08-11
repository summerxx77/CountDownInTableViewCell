//
//  CustomCell.m
//  列表内倒计时 Demo
//
//  Created by summerxx on 2020/8/11.
//  Copyright © 2020 summerxx. All rights reserved.
//

#import "CustomCell.h"
#import "Models.h"
#import "Masonry.h"
#import "View+MASAdditions.h"
#import "View+MASShorthandAdditions.h"
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;
@interface CustomCell()
@property (nonatomic, weak) id tData;
@property (nonatomic, weak) NSIndexPath *tIndexPath;
@property (nonatomic, strong) UILabel *remainingTimeDesL;
@property (nonatomic, strong) UILabel *desL;

@end


@implementation CustomCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self regisNSNotificationCenter];
        [self setSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setSubViews
{
    _remainingTimeDesL = [[UILabel alloc] init];
    [self.contentView addSubview:_remainingTimeDesL];
    [_remainingTimeDesL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(30);
        make.top.mas_equalTo(self.contentView.mas_top).offset(193);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(33);
    }];
    
    _desL = [[UILabel alloc] init];
    [self.contentView addSubview:_desL];
    [_desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(30);
        make.top.mas_equalTo(self.remainingTimeDesL.mas_bottom).offset(0);
        make.right.mas_equalTo(33);
        make.height.mas_equalTo(33);
    }];
    
    _remainingTimeDesL.text = @"助力剩余时间";
    _remainingTimeDesL.textColor = [UIColor blackColor];
}

- (void)setModel:(Models *)model
{
    _model = model;
    _desL.text = model.des;
}

- (void)regisNSNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterEvent:) name:@"COUPON_TIME_DOWN" object:nil];
}

- (void)removeNSNotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"COUPON_TIME_DOWN" object:nil];
}

- (void)dealloc
{
    [self removeNSNotificationCenter];
}

- (void)notificationCenterEvent:(id)obj
{
    if (self.isDisplayed) {
        [self loadData:self.tData indexPath:self.tIndexPath];
    }
}

- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf)
    if ([data isMemberOfClass:[Models class]]) {
        Models *model = (Models *)data;
        [self storeWeakValueWithData:data indexPath:indexPath];
        [model getCurrentTimeStringResult:^(NSString * _Nonnull hour, NSString * _Nonnull minutes, NSString * _Nonnull seconds, NSInteger type) {
            weakSelf.remainingTimeDesL.text = [NSString stringWithFormat:@"%@:%@:%@", hour, minutes, seconds];
        }];
    }
}

- (void)storeWeakValueWithData:(id)data indexPath:(NSIndexPath *)indexPath
{
    self.tData = data;
    self.tIndexPath = indexPath;
}
@end
