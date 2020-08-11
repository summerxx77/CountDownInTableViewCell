//
//  Models.h
//  列表内倒计时 Demo
//
//  Created by summerxx on 2020/8/11.
//  Copyright © 2020 summerxx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^currentTimeStringCallBack)(NSString *hour, NSString *minutes, NSString *seconds, NSInteger type);
@interface Models : NSObject
@property (nonatomic, assign) SInt64 remainTime;         ///< 剩余时间
@property (nonatomic, copy) NSString *des;                ///< 描述
@property (nonatomic, assign) NSTimeInterval countNum;   ///< 时间-秒
- (void)countDown;
- (void)getCurrentTimeStringResult:(currentTimeStringCallBack)result;
@end

NS_ASSUME_NONNULL_END
