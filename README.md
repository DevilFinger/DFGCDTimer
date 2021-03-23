# DFGCDTimer
DFGCDTimer is implementation of NSTimer-like class with API close to original, but done on top of Apple's GCD (Grand Central Dispatch).

## Requirements
This component requires iOS 8.0+.

## Installation
Copy the file `DFTimer.h` and `DFTimer.m` to your project

## Usage

### Create No Repeat Timer
```
//create a timer which fires a single time after 2 seconds.
self.timerEx = [DFTimer onceAfter:2 handler:^(DFTimer *timer) {
        NSLog(@"do something");
}];
        
//create a timer in specify queue which fires a single time after 1 seconds.
self.timerEx = [DFTimer onceInQueue:dispatch_get_main_queue() after:1 handler:^(DFTimer *timer) {
        NSLog(@"do something");
}];
```

### Create Repeat Timer
```       
// create a Repeat timer which fires every 1 seconds
    self.timerEx = [DFTimer everyWithInterval:1 handler:^(DFTimer *timer) {
        NSLog(@"everyWithInterval");
    }];
 
 //create a Repeat timer which fires every 1 seconds. 
 //it will auto stop when fire 3 times
   self.timerEx = [DFTimer everyWithInterval:1 repeatTimes:3 handler:^(DFTimer *timer) {
        NSLog(@"everyWithInterval");
    }];

// create a Repeat timer in specify queue. it will begin after 2 second . 
// and then fire every 1 seconds and repeat 3 times.
    self.timerEx = [DFTimer everyInQueue:dispatch_get_main_queue() after:2 interval:1 repeatTimes:3 handler:^(DFTimer *timer) {
        NSLog(@"everyWithInterval");
        NSLog(@"thread %@", [NSThread currentThread]);
    }];
 
 ```
 ### Others
 
 ```
 //Whether it is a background task, after it is turned on, even if the APP exits to the background, the task will continue to be executed
 self.timerEx.isBackgroundMode = YES
 
 //Timer status monitoring. You can monitor the current status of the timer. Such as execution, suspension, cancellation
    self.timerEx.observer = ^(DFTimer *timer, DFTimerState state) {
        NSLog(@"state %@", @(state));
    };

//Start or resume the timer
[self.timerEx fire];
        
//Pause the timer
[self.timerEx pause];
        
//Cancel timer
[self.timerEx cancel];

 ```
### License
DFGCDTimer is available under the MIT license. See the LICENSE file for more info.
