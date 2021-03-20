//
//  DFGCDTimerManager.m
//  DFGCDTimer
//
//  Created by raymond on 2021/3/19.
//

#import "DFGCDTimerManager.h"
#import "DFGCDTimer.h"

@interface DFGCDTimerManager()

@property (nonatomic, strong) NSMutableDictionary *mDict;

@end

@implementation DFGCDTimerManager

+(DFGCDTimerManager *)sharedManger{
    
    static dispatch_once_t once;
    static DFGCDTimerManager *sharedManger;
    dispatch_once(&once, ^{
        sharedManger = [DFGCDTimerManager new];
    });
    return sharedManger;
}

-(instancetype) init{
    self = [super init];
    if(self){
        self.mDict = [NSMutableDictionary new];
    }
    return self;
    
}


-(void)scheduledTimerWithKey:(NSString *)key
                               queue:(dispatch_queue_t)queue
                        timeInterval:(NSInteger)timeInterval
                               delay:(NSInteger)delay
                           isRepeats:(BOOL)isRepeats{
    
    
    if(![self.mDict.allKeys containsObject:key]){
        __weak typeof(self) weakSelf = self;
        DFGCDTimer *gcdTimer = [DFGCDTimer scheduledTimerWithQueue:queue timeInterval:timeInterval delay:delay isRepeats:isRepeats hanlder:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(dfGCDTimerManagerDidFiredWithKey:)]) {
                [weakSelf.delegate dfGCDTimerManagerDidFiredWithKey:key];
            }
        }];
        [self.mDict setObject:gcdTimer forKey:key];
    }
}

-(void)cancelTimerWithKey:(NSString *)key{
    
    DFGCDTimer *gcdTimer = [self.mDict objectForKey:key];
    if (gcdTimer) {
        [gcdTimer cancel];
        [self.mDict removeObjectForKey:key];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dfGCDTimerManagerDidCancelWithKey:)]) {
            [self.delegate dfGCDTimerManagerDidCancelWithKey:key];
        }
    }
    
    
}

-(void)cancleAllTimer{
    
    NSArray *keys = self.mDict.allKeys;
    for (NSString *key in keys) {
        [self cancelTimerWithKey:key];
    }
}

-(void)pauseTimerWithKey:(NSString *)key{
    DFGCDTimer *gcdTimer = [self.mDict objectForKey:key];
    if (gcdTimer) {
        [gcdTimer pause];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dfGCDTimerManagerDidPauseWithKey:)]) {
            [self.delegate dfGCDTimerManagerDidPauseWithKey:key];
        }
    }
    
}

-(void)pauseAllTimer{
    
    NSArray *keys = self.mDict.allKeys;
    for (NSString *key in keys) {
        [self pauseTimerWithKey:key];
    }
}

-(void)startTimerWithKey:(NSString *)key{
    DFGCDTimer *gcdTimer = [self.mDict objectForKey:key];
    if (gcdTimer) {
        [gcdTimer start];
        if (self.delegate && [self.delegate respondsToSelector:@selector(dfGCDTimerManagerDidFiredWithKey:)]) {
            [self.delegate dfGCDTimerManagerDidFiredWithKey:key];
        }
    }
    
}

-(void)startAllTimer{
    
    NSArray *keys = self.mDict.allKeys;
    for (NSString *key in keys) {
        [self startTimerWithKey:key];
    }
}

@end
