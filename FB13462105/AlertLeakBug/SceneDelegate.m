//
//  SceneDelegate.m
//  AlertLeakBug
//
//  Created by Jinwoo Kim on 12/12/23.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (void)dealloc {
    
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    window.rootViewController = [ViewController new];
    [window makeKeyAndVisible];
    self.window = window;
}

@end
