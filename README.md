# DFGCDTimer
DFGCDTimer is implementation of NSTimer-like class with API close to original, but done on top of Apple's GCD (Grand Central Dispatch).

## Requirements
This component requires iOS 8.0+.

## Installation
Copy the file to your project to use

## Usage
1. How to create a Timer

```
__weak typeof(self) weakSelf = self;
DFGCDTimer *gcdTimer = [DFGCDTimer scheduledTimerWithQueue:nil timeInterval:1 delay:0 isRepeats:YES hanlder:^{
        [weakSelf doSomeThing];
}];
```

2. suspend the timer

```
[self.gcdTimer pause];
```

3. close or cancel the timer

```
[self.gcdTimer cancel];
```

4. start or resume the timer

```
[self.gcdTimer start];
```

## If you want to manage multiple Timers, you can use DFGCDTimerManager to manage them. This is a singleton manager. Use Key to manage Timer, such as create, cancel, pause, resume, etc. As the name is the unique key of the timer. Make sure to use unique names for timer instances.

1. Create Timer by unique Key in singleton mode

```
 [[DFGCDTimerManager sharedManger] scheduledTimerWithKey:@"first" queue:nil timeInterval:1 delay:0 isRepeats:YES];
```

2. Pause Timer by unique Key in singleton mode

```
[[DFGCDTimerManager sharedManger] pauseTimerWithKey:@"first"];
```

3. Close or Cancel Timer by unique Key in singleton mode

```
[[DFGCDTimerManager sharedManger] cancelTimerWithKey:@"first"];
```

4. Start or Resume Timer by unique Key in singleton mode

```
[[DFGCDTimerManager sharedManger] startTimerWithKey:@"first"];
```
5. Receive function callbacks through Delegate

```
[DFGCDTimerManager sharedManger].delegate = self;

-(void)dfGCDTimerManagerDidFiredWithKey:(NSString *)key{
    NSLog(@"dfGCDTimerManagerDidFiredWithKey %@", key);
   
}

-(void)dfGCDTimerManagerDidCancelWithKey:(NSString *)key{
    NSLog(@"dfGCDTimerManagerDidCancelWithKey %@", key);
}

-(void)dfGCDTimerManagerDidPauseWithKey:(NSString *)key{
    NSLog(@"dfGCDTimerManagerDidPauseWithKey %@", key);
}


```

### License
DFGCDTimer is available under the MIT license. See the LICENSE file for more info.
