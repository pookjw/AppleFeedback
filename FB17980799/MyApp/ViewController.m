//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 6/12/25.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISliderTrackConfiguration *trackConfiguration = [UISliderTrackConfiguration configurationWithNumberOfTicks:3];
    trackConfiguration.maximumEnabledValue = 2.f;
    trackConfiguration.minimumEnabledValue = 1.1f;
    [trackConfiguration copy];
}


@end
