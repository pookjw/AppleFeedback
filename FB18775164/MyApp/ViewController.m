//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 7/11/25.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>

@interface ViewController () {
    AVInputPickerInteraction *_interaction;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _interaction = [[AVInputPickerInteraction alloc] initWithAudioSession:AVAudioSession.sharedInstance];
    [self.view addInteraction:_interaction];
}

- (IBAction)presentButtonDidTrigger:(UIButton *)sender {
    [_interaction present];
}

- (IBAction)dismissWithDelayButtonDidTrigger:(UIButton *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Dismiss!");
        [_interaction dismiss];
    });
}

@end
