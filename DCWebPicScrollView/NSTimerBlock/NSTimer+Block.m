//
//  NSTimer+Block.m
//  DCWebPicScrollView
//
//  Created by ShannonChen on 15/12/27.
//  Copyright © 2015年 name. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)

+ (instancetype)block_timerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats {
    return [self timerWithTimeInterval:interval target:self selector:@selector(block_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (instancetype)block_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(block_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)block_blockInvoke:(NSTimer *)timer {
    if (!timer.isValid) return;
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
