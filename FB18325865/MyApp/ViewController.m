//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong) IBOutlet NSSlider *slider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // {{0, 0}, {0, 0}}
        NSLog(@"%@", NSStringFromRect([self.slider rectOfTickMarkAtIndex:3]));
        
        // NSNotFound
        NSLog(@"%ld", [self.slider indexOfTickMarkAtPoint:NSMakePoint(NSMidX(self.slider.bounds), NSMidY(self.slider.bounds))]);
    });
}

@end
