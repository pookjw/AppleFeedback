//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 6/27/24.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Menu"];
    
    NSMenuItem *firstMenuItem = [[NSMenuItem alloc] initWithTitle:@"First" action:nil keyEquivalent:@""];
    [menu addItem:firstMenuItem];
    
    NSMenuItem *secondMenuItem = [[NSMenuItem alloc] initWithTitle:@"Second" action:nil keyEquivalent:@""];
    [menu addItem:secondMenuItem];
    
    NSMenuItem *thirdMenuItem = [[NSMenuItem alloc] initWithTitle:@"Third" action:nil keyEquivalent:@""];
    [menu addItem:thirdMenuItem];
    
    //
    
    NSPopUpButton *pullDownButton = [NSPopUpButton pullDownButtonWithTitle:@"Hello!" menu:menu];
    
    pullDownButton.usesItemFromMenu = YES;
    
    pullDownButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:pullDownButton];
    [NSLayoutConstraint activateConstraints:@[
        [pullDownButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [pullDownButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    //
    
    /* usesItemFromMenu works when uncommenting this code */
    pullDownButton.menu = menu;
}

@end
