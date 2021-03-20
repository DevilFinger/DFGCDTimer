//
//  DFGCDTimer.m
//  DFGCDTimer
//
//  Created by raymond on 2021/3/19.
//

#import "DFGCDTimer.h"


@interface DFGCDTimer()

@property (nonatomic, assign) BOOL isRepeats;
@property (nonatomic, assign) NSInteger timeInterval;
@property (nonatomic, assign) NSInteger delay;

@property (nonatomic, strong) dispatch_source_t gcdTimer;

@property (nonatomic, weak) dispatch_queue_t queue;

@property (nonatomic, copy) dispatch_block_t handler;

@end

@implementation DFGCDTimer

+(DFGCDTimer *)scheduledTimerWithQueue:(dispatch_queue_t)queue timeInterval:(NSInteger)timeInterval delay:(NSInteger)delay isRepeats:(BOOL)isRepeats hanlder:(dispatch_block_t)hanlder{
    
    
    DFGCDTimer *gcdTimer = [[DFGCDTimer alloc] initWithQueue:queue timeInterval:timeInterval delay:delay isRepeats:isRepeats hanlder:hanlder];
    return  gcdTimer;
}

-(instancetype) initWithQueue:(dispatch_queue_t)queue timeInterval:(NSInteger)timeInterval delay:(NSInteger)delay isRepeats:(BOOL)isRepeats hanlder:(dispatch_block_t)hanlder{
    
    self = [super init];
    if (self) {
      
        self.isRepeats = isRepeats;
        self.timeInterval = timeInterval;
        self.delay = delay;
        
        dispatch_queue_t timerQueue = queue;
        if(!timerQueue){
            timerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //dispatch_get_main_queue();
        }
        self.queue = timerQueue;
        
        self.handler = hanlder;
        
        [self start];
        
    }
    return self;
}

-(void)start{
    if(self.gcdTimer){
        [self cancel];
    }
    self.gcdTimer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(self.gcdTimer, dispatch_time(DISPATCH_TIME_NOW, self.delay * NSEC_PER_SEC), self.timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.gcdTimer, ^{
        
        if(weakSelf.handler){
            weakSelf.handler();
        }
        
        if(!weakSelf.isRepeats){
            [weakSelf cancel];
        }
    });
    dispatch_resume(self.gcdTimer);
}

-(void)pause{
    [self cancel];
}

-(void)cancel{
    if(self.gcdTimer){
        dispatch_source_cancel(self.gcdTimer);
        self.gcdTimer = nil;
    }
}


-(void)dealloc{
    if(self.handler){
        self.handler = nil;
    }
    
    if (self.queue) {
        self.queue = nil;
    }
    [self cancel];
}



@end
