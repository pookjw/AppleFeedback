//
//  SceneDelegate.m
//  MyApp
//
//  Created by Jinwoo Kim on 7/10/24.
//

#import "SceneDelegate.h"
#import "CollectionViewController.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    CollectionViewController *rootViewController = [CollectionViewController new];
    window.rootViewController = rootViewController;
    [rootViewController release];
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
