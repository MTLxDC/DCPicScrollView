//
//  NSTimer+Block.h
//  DCWebPicScrollView
//
//  Created by ShannonChen on 15/12/27.
//  Copyright © 2015年 name. All rights reserved.
//  参考《Effective Objective-C 2.0》 第52条

#import <Foundation/Foundation.h>

@interface NSTimer (Block)

/// 需要手动加入runloop中
+ (instancetype)block_timerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

/// 自动加入runloop中
+ (instancetype)block_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)())block repeats:(BOOL)repeats;

@end
