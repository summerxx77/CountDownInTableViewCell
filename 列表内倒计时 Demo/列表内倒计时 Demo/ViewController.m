//
//  ViewController.m
//  列表内倒计时 Demo
//
//  Created by summerxx on 2020/8/11.
//  Copyright © 2020 summerxx. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "Masonry.h"
#import "Models.h"
static NSString *couponHelpCell = @"CustomCell";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSTimer *timerObser;
@property (nonatomic, strong) NSMutableArray *couponArray;
@end

@implementation ViewController

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    [self.timerObser invalidate];
    self.timerObser = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self createTimer];
}

- (void)setUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Models *model = [[Models alloc] init];
    model.des = @"夏天然后";
    model.remainTime = 100000;
    [self.couponArray addObject:model];
    
    Models *model1 = [[Models alloc] init];
    model1.remainTime = 00000;
    [self.couponArray addObject:model1];
    
    Models *model2 = [[Models alloc] init];
    model2.remainTime = 40000;
    [self.couponArray addObject:model2];
    
    Models *model3 = [[Models alloc] init];
    model3.remainTime = 30000;
    [self.couponArray addObject:model3];
    
    Models *model4 = [[Models alloc] init];
    model4.remainTime = 3000;
    [self.couponArray addObject:model4];
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:couponHelpCell];
    cell.model = self.couponArray[indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *displayCell = (CustomCell *)cell;
    displayCell.isDisplayed = YES;
    [displayCell loadData:_couponArray[indexPath.row] indexPath:indexPath];
}

- (void)createTimer
{
    self.timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        for (int index = 0; index < _couponArray.count; index ++) {
            Models *model = _couponArray[index];
            [model countDown];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"COUPON_TIME_DOWN" object:nil];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 每秒去监听当前屏幕显示范围内的倒计时
    self.timerObser = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        NSMutableArray *cellModels = [NSMutableArray array];
        // 先把 cell 绑定的 model 取出来放到一个数组里
        for (CustomCell *cell in self.tableView.visibleCells) {
            [cellModels addObject:cell.model];
        }
        // 对 model 数组进行除 0 排序  [40s 30s 0s] 排序后为 [30s, 40s] 也就是 30s 后要进行刷新列表
        NSSortDescriptor *levelSD = [NSSortDescriptor sortDescriptorWithKey:@"countNum" ascending:YES];
        cellModels = [[cellModels sortedArrayUsingDescriptors:@[levelSD]] mutableCopy];
        NSMutableArray *cellCopy = [cellModels mutableCopy];
        for (int i = 0; i < cellModels.count; i ++) {
            Models *model = cellModels[i];
            if (model.countNum == 0) {
                [cellCopy removeObject:model];
            }
        }
        Models *m = cellCopy.firstObject;
        NSInteger time = m.countNum;
        // 30s后刷新
        [self performSelector:@selector(afterDelayReloadTabview) withObject:nil afterDelay:time];
    }];;
    [[NSRunLoop mainRunLoop] addTimer:self.timerObser forMode:NSRunLoopCommonModes];

}

- (void)afterDelayReloadTabview
{
    [self.couponArray removeAllObjects];
    
    Models *model = [[Models alloc] init];
    model.des = @"summerxx.com";
    model.remainTime = 100000;
    [self.couponArray addObject:model];
    
    Models *model1 = [[Models alloc] init];
    model1.remainTime = 00000;
    [self.couponArray addObject:model1];
    
    Models *model2 = [[Models alloc] init];
    model2.remainTime = 40000;
    [self.couponArray addObject:model2];
    
    Models *model3 = [[Models alloc] init];
    model3.remainTime = 30000;
    [self.couponArray addObject:model3];
    
    Models *model4 = [[Models alloc] init];
    model4.remainTime = 3000;
    [self.couponArray addObject:model4];
    
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.separatorStyle = UITableViewScrollPositionNone;
        [_tableView registerClass:[CustomCell class] forCellReuseIdentifier:couponHelpCell];
    }
    return _tableView;
}

- (NSMutableArray *)couponArray
{
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}



@end
