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
    
    UISplitViewController *sv = [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleTripleColumn];
    
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = UIColor.systemBackgroundColor;
    [sv setViewController:vc1 forColumn:UISplitViewControllerColumnPrimary];
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = UIColor.systemBackgroundColor;
    vc2.navigationItem.searchController = [UISearchController new];
    [sv setViewController:vc2 forColumn:UISplitViewControllerColumnSupplementary];
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = UIColor.systemBackgroundColor;
    [sv setViewController:vc3 forColumn:UISplitViewControllerColumnSecondary];
    
    [self addChildViewController:sv];
    sv.view.frame = self.view.bounds;
    sv.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:sv.view];
    [sv didMoveToParentViewController:self];
    
    UIAction *action = [UIAction actionWithTitle:@"Toggle" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        vc2.navigationItem.searchBarPlacementAllowsExternalIntegration = !vc2.navigationItem.searchBarPlacementAllowsExternalIntegration;
        
        // Uncoment this to fix
//        [vc2.view setNeedsLayout];
//        for (UIViewController *vc in sv.viewControllers) {
//            [vc.navigationController.navigationBar setNeedsLayout];
//        }
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithPrimaryAction:action];
}


@end
