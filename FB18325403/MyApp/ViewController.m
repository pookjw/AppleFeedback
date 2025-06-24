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
//    self.slider.tickMarkPosition = NSTickMarkPositionBelow;
    self.slider.tickMarkPosition = NSTickMarkPositionAbove;
}

@end
