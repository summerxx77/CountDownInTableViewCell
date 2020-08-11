//
//  Models.m
//  列表内倒计时 Demo
//
//  Created by summerxx on 2020/8/11.
//  Copyright © 2020 summerxx. All rights reserved.
//

#import "Models.h"

@implementation Models
- (void)setRemainTime:(SInt64)remainTime
{
    self.countNum = remainTime / 1000;
    _remainTime = remainTime;
}

- (void)countDown
{
    self.countNum -= 1;
    _remainTime -= 1000;
    if (self.countNum <= 0) {
        self.countNum = 0;
        
    }
}

- (void)getCurrentTimeStringResult:(currentTimeStringCallBack)result
{
    if (self.countNum <= 0) {
        result(@"00", @"00", @"00", 0);
    }else {
        NSString *hourString = [NSString stringWithFormat:@"%02ld", (long)self.countNum / 3600];
        NSString *minString = [NSString stringWithFormat:@"%02ld", (long)self.countNum % 3600 / 60];
        NSString *secString = [NSString stringWithFormat:@"%02ld", (long)self.countNum % 60];
        result(hourString, minString, secString, 1);
    }
}
@end
