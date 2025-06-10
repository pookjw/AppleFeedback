//
//  SceneDelegate.m
//  MyApp
//
//  Created by Jinwoo Kim on 4/25/25.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    ViewController *viewController = [ViewController new];
    window.rootViewController = viewController;
    [viewController release];
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
