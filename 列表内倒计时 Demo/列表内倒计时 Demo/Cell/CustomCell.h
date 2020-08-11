//
//  CustomCell.h
//  列表内倒计时 Demo
//
//  Created by summerxx on 2020/8/11.
//  Copyright © 2020 summerxx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Models;
@interface CustomCell : UITableViewCell
@property (nonatomic, copy) Models *model;
@property (nonatomic, assign) BOOL isDisplayed;
- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
