//
//  DFGCDTimer.h
//  DFGCDTimer
//
//  Created by raymond on 2021/3/19.
//

#import <Foundation/Foundation.h>


@interface DFGCDTimer : NSObject

+(DFGCDTimer *)scheduledTimerWithQueue:(dispatch_queue_t)queue timeInterval:(NSInteger)timeInterval delay:(NSInteger)delay isRepeats:(BOOL)isRepeats hanlder:(dispatch_block_t)hanlder;

-(instancetype) initWithQueue:(dispatch_queue_t)queue timeInterval:(NSInteger)timeInterval delay:(NSInteger)delay isRepeats:(BOOL)isRepeats hanlder:(dispatch_block_t)hanlder;

-(void)start;
-(void)cancel;
-(void)pause;

@end


