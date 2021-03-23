//
//  ViewController.m
//  DFGCDTimer
//
//  Created by raymond on 2021/3/19.
//

#import "ViewController.h"
#import "DFTimer.h"

@interface ViewController ()


@property (nonatomic, strong) DFTimer *timerEx;

@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *timesLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self timerAction];
}


-(void)timerAction{
    
    
    self.timerEx = [DFTimer onceAfter:2 handler:^(DFTimer *timer) {
        NSLog(@"onece after");
    }];
    
//    self.timerEx = [DFTimer onceInQueue:dispatch_get_main_queue() after:1 handler:^(DFTimer *timer) {
//        NSLog(@"thread %@", [NSThread currentThread]);
//    }];
    
//    self.timerEx = [DFTimer everyWithInterval:1 handler:^(DFTimer *timer) {
//        NSLog(@"everyWithInterval");
//    }];
    
    
//    self.timerEx = [DFTimer everyWithInterval:1 repeatTimes:3 handler:^(DFTimer *timer) {
//        NSLog(@"everyWithInterval");
//    }];
    
//    self.timerEx = [DFTimer everyInQueue:dispatch_get_main_queue() after:2 interval:1 repeatTimes:3 handler:^(DFTimer *timer) {
//        NSLog(@"everyWithInterval");
//        NSLog(@"thread %@", [NSThread currentThread]);
//    }];
    
//    self.timerEx = [[DFTimer alloc] initWithQueue:nil after:1 interval:1 isRepeats:YES repeatCounts:0 leeway:0 hanlder:^(DFTimer *timer) {
//        NSLog(@"initWithQueue");
//    }];
    
    self.timerEx.observer = ^(DFTimer *timer, DFTimerState state) {
        NSLog(@"state %@", @(state));
    };
    
    NSLog(@"timer fired");
    [self.timerEx fire];
    
}

- (IBAction)resumeBtnDidClicked:(id)sender {
   
    [self.timerEx fire];
}

- (IBAction)pauseBtnDidClicked:(id)sender {
    [self.timerEx pause];
    
}

- (IBAction)cancelBtnDidClicked:(id)sender {
    [self.timerEx cancel];
}

@end
