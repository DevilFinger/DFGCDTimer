//
//  DFTimer.h
//  DFGCDTimer
//
//  Created by raymond on 2021/3/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DFTimerState){
    DFTimerStateRegister,
    DFTimerStateExctuing,
    DFTimerStatePause,
    DFTimerStateCancel,
};

@interface DFTimer : NSObject

@property (nonatomic, assign) BOOL isBackgroundMode;
@property (nonatomic, copy) void(^observer)(DFTimer* timer, DFTimerState state);
@property (nonatomic, copy) NSString *identifier;

+(DFTimer *)onceAfter:(CGFloat)after handler:(void(^)(DFTimer* timer))handler;

+(DFTimer *)onceInQueue:(dispatch_queue_t)queue after:(CGFloat)after handler:(void(^)(DFTimer* timer))handler;

+(DFTimer *)everyWithInterval:(CGFloat)interval handler:(void(^)(DFTimer* timer))handler;

+(DFTimer *)everyWithInterval:(CGFloat)interval repeatTimes:(NSInteger)repeatTimes handler:(void(^)(DFTimer* timer))handler;

+(DFTimer *)everyInQueue:(dispatch_queue_t)queue after:(CGFloat)after interval:(CGFloat)interval repeatTimes:(NSInteger)repeatTimes handler:(void(^)(DFTimer* timer))handler;

-(instancetype) initWithQueue:(dispatch_queue_t)queue
                        after:(NSInteger)after
                     interval:(double)interval
                    isRepeats:(BOOL)isRepeats
                 repeatCounts:(NSInteger)repeatCounts
                       leeway:(NSInteger)leeway
                      hanlder:(void(^)(DFTimer* timer))handler;

-(void)fire;
-(void)pause;
-(void)cancel;

@end
