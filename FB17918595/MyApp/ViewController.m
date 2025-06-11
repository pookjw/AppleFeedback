//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.searchController = [UISearchController new];
    self.navigationItem.preferredSearchBarPlacement = UINavigationItemSearchBarPlacementIntegratedCentered;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationItem.searchBarPlacementAllowsToolbarIntegration = NO;
    });
}


@end
