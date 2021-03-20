//
//  DFGCDTimerManager.h
//  DFGCDTimer
//
//  Created by raymond on 2021/3/19.
//

#import <Foundation/Foundation.h>

@protocol DFGCDTimerManagerDelegate <NSObject>

@required
-(void)dfGCDTimerManagerDidFiredWithKey:(NSString *)key;

@optional

-(void)dfGCDTimerManagerDidCancelWithKey:(NSString *)key;
-(void)dfGCDTimerManagerDidPauseWithKey:(NSString *)key;

@end



@interface DFGCDTimerManager : NSObject

@property (nonatomic, weak) id<DFGCDTimerManagerDelegate> delegate;


+(DFGCDTimerManager *)sharedManger;
-(void)scheduledTimerWithKey:(NSString *)key
                               queue:(dispatch_queue_t)queue
                        timeInterval:(NSInteger)timeInterval
                               delay:(NSInteger)delay
                   isRepeats:(BOOL)isRepeats;

-(void)startTimerWithKey:(NSString *)key;
-(void)startAllTimer;

-(void)pauseTimerWithKey:(NSString *)key;
-(void)pauseAllTimer;

-(void)cancelTimerWithKey:(NSString *)key;
-(void)cancleAllTimer;

@end

