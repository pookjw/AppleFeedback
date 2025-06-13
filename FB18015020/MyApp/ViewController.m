//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"apple.intelligence"] menu:nil];
        UIBarButtonItemBadge *badge = [UIBarButtonItemBadge badgeWithString:@"Badge"];
        barButtonItem.badge = badge;
        self.navigationItem.rightBarButtonItem = barButtonItem;
        [barButtonItem release];
    }
    
    {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"apple.intelligence"] menu:nil];
        UIBarButtonItemBadge *badge = [UIBarButtonItemBadge badgeWithString:@"Badge"];
        barButtonItem.badge = badge;
        self.toolbarItems = @[barButtonItem];
        [barButtonItem release];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    if ([parent isKindOfClass:[UINavigationController class]]) {
        ((UINavigationController *)parent).toolbarHidden = NO;
    }
}


@end
