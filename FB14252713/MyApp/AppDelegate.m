//
//  AppDelegate.m
//  MyApp
//
//  Created by Jinwoo Kim on 7/10/24.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *configuration = [connectingSceneSession.configuration copy];
    configuration.delegateClass = SceneDelegate.class;
    return [configuration autorelease];
}

@end
