//
//  DFTimer.m
//  DFGCDTimer
//
//  Created by raymond on 2021/3/23.
//

#import "DFTimer.h"



@interface DFTimer()

@property (nonatomic, assign) CGFloat after;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, assign) BOOL isRepeat;
@property (nonatomic, assign) NSInteger repeats;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) CGFloat leeway;

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_source_t gcdTimer;
@property (nonatomic, assign) DFTimerState state;

@property (nonatomic, assign) BOOL isAddObserver;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

@property (nonatomic, copy) void(^handler)(DFTimer* timer);


@end

@implementation DFTimer

+(DFTimer *)onceAfter:(CGFloat)after handler:(void(^)(DFTimer* timer))handler{
    return [[DFTimer alloc] initWithQueue:nil after:after interval:0 isRepeats:NO repeatCounts:0 leeway:0 hanlder:handler];
}

+(DFTimer *)onceInQueue:(dispatch_queue_t)queue after:(CGFloat)after handler:(void(^)(DFTimer* timer))handler{
    return [[DFTimer alloc] initWithQueue:queue after:after interval:0 isRepeats:NO repeatCounts:0 leeway:0 hanlder:handler];
}

+(DFTimer *)everyWithInterval:(CGFloat)interval handler:(void(^)(DFTimer* timer))handler{
    return [[DFTimer alloc] initWithQueue:nil after:0 interval:interval isRepeats:YES repeatCounts:0 leeway:0 hanlder:handler];
}

+(DFTimer *)everyWithInterval:(CGFloat)interval repeatTimes:(NSInteger)repeatTimes handler:(void(^)(DFTimer* timer))handler{
    return  [[DFTimer alloc] initWithQueue:nil after:0 interval:interval isRepeats:YES repeatCounts:repeatTimes leeway:0 hanlder:handler];
}

+(DFTimer *)everyInQueue:(dispatch_queue_t)queue after:(CGFloat)after interval:(CGFloat)interval repeatTimes:(NSInteger)repeatTimes handler:(void(^)(DFTimer* timer))handler{
    return  [[DFTimer alloc] initWithQueue:queue after:after interval:interval isRepeats:YES repeatCounts:repeatTimes leeway:0 hanlder:handler];
}

-(instancetype) initWithQueue:(dispatch_queue_t)queue
                        after:(NSInteger)after
                     interval:(double)interval
                    isRepeats:(BOOL)isRepeats
                 repeatCounts:(NSInteger)repeatCounts
                       leeway:(NSInteger)leeway
                      hanlder:(void(^)(DFTimer* timer))handler{
    self = [super init];
    if(self){
        
        self.queue = dispatch_queue_create("com.DevilFinger.com", NULL);
        if(nil != queue){
            self.queue = queue;
        }
        self.after = after;
        self.interval = interval;
        self.isRepeat = isRepeats;
        self.repeats = repeatCounts;
        self.leeway = leeway;
        self.handler = handler;
        self.isAddObserver = NO;
        self.isBackgroundMode = NO;
        self.backgroundTask = -1;
    }
    return self;
}

-(void)_create{
    self.gcdTimer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(self.gcdTimer, dispatch_time(DISPATCH_TIME_NOW, self.after * NSEC_PER_SEC), self.interval * NSEC_PER_SEC, self.leeway * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.gcdTimer, ^{
        
        if(weakSelf.handler){
            weakSelf.handler(weakSelf);
        }
        
        if(weakSelf.isRepeat){
            if(weakSelf.repeats > 0){
                weakSelf.current++;
                if (weakSelf.current == weakSelf.repeats){
                    weakSelf.current = 0;
                    [weakSelf cancel];
                }
            }
        }else{
            //dispatch_source_cancel(weakSelf.gcdTimer);
            [weakSelf cancel];
        }
        
        
        
    });
}

-(void)_release{
    
    if(self.gcdTimer){
        dispatch_source_set_event_handler(self.gcdTimer, nil);
        dispatch_source_cancel(self.gcdTimer);
        self.gcdTimer = nil;
    }
}

-(void)fire{
    if(self.gcdTimer){
        if(self.state == DFTimerStateRegister){
            dispatch_resume(self.gcdTimer);
        }
    }else{
        [self _create];
        dispatch_resume(self.gcdTimer);
    }
    self.state = DFTimerStateExctuing;
    [self _observerCallBack];
}

-(void)pause{
    [self _release];
    self.state = DFTimerStatePause;
    [self _observerCallBack];
}

-(void)cancel{
    [self _release];
    self.state = DFTimerStateCancel;
    [self _observerCallBack];
}

-(void)_observerCallBack{
    
    if(self.observer){
        self.observer(self, self.state);
    }
}

-(void)appDidEnterBackground:(NSNotification *)notification{
    UIApplication *application = UIApplication.sharedApplication;
    if(self.backgroundTask != -1){
        [application endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
    
    [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
}

-(void)setIsBackgroundMode:(BOOL)isBackgroundMode{
    
    BOOL oldValue = _isBackgroundMode;
    
    _isBackgroundMode = isBackgroundMode;
    
    if (oldValue != isBackgroundMode){
        
        if (isBackgroundMode){
            [self _addEnterBackgroundObserver];
        }else{
            [self _removeEnterBackgroundObserver];
        }
    }
}

-(void)_addEnterBackgroundObserver{
    
    
    if (@available(iOS 13.0, *)) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidEnterBackground:) name:UISceneDidEnterBackgroundNotification object:nil];
    } else {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}


-(void)_removeEnterBackgroundObserver{
    
    if (@available(iOS 13.0, *) ) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:UISceneDidEnterBackgroundNotification object:nil];
    } else {
        [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
      
    }
    
}
@end
