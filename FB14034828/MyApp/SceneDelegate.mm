//
//  SceneDelegate.m
//  MyApp
//
//  Created by Jinwoo Kim on 6/24/24.
//

#import "SceneDelegate.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <objc/message.h>
#import <objc/runtime.h>

// Uncommnet to fix the problem

//namespace _MCAlertController {
//    namespace show {
//        void (*original)(id, SEL);
//        void custom(__kindof UIViewController *self, SEL _cmd) {
//            UIWindowScene *activeWindowScene = nil;
//            
//            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
//                if ([scene isKindOfClass:UIWindowScene.class]) {
//                    UIWindowScene *windowScene = (UIWindowScene *)scene;
//                    
//                    if (windowScene.activationState == UISceneActivationStateForegroundActive) {
//                        activeWindowScene = windowScene;
//                        break;
//                    }
//                }
//            }
//            
//            UIWindow *window = [[UIWindow alloc] initWithWindowScene:activeWindowScene];
//            
//            ((void (*)(id, SEL, id))objc_msgSend)(self, sel_registerName("setAlertWindow:"), window);
//            
//            UIViewController *rootViewController = [UIViewController new];
//            window.rootViewController = rootViewController;
//            
//            window.windowLevel = UIWindowLevelAlert;
//            [window makeKeyAndVisible];
//            [rootViewController presentViewController:self animated:YES completion:nil];
//        }
//    }
//}
//
//@interface FooObject : NSObject
//@end
//@implementation FooObject
//+ (void)load {
//    using namespace _MCAlertController::show;
//    Method method = class_getInstanceMethod(objc_lookUpClass("MCAlertController"), sel_registerName("show"));
//    original = (decltype(original))method_getImplementation(method);
//    method_setImplementation(method, (IMP)custom);
//}
//@end

@interface SceneDelegate ()
@property (retain, readonly, nonatomic) MCSession *session;
@property (retain, readonly, nonatomic) MCAdvertiserAssistant *advertiserAssistant;
@end

@implementation SceneDelegate
@synthesize session = _session;
@synthesize advertiserAssistant = _advertiserAssistant;

- (void)dealloc {
    [_window release];
    [_session release];
    
    if (auto advertiserAssistant = _advertiserAssistant) {
        [advertiserAssistant stop];
        [advertiserAssistant release];
    }
    
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:static_cast<UIWindowScene *>(scene)];
    
    MCBrowserViewController *rootViewController = [[MCBrowserViewController alloc] initWithServiceType:@"ar-collab" session:self.session];
    
    window.rootViewController = rootViewController;
    [rootViewController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
    
    [self.advertiserAssistant start];
}

- (MCSession *)session {
    if (auto session = _session) return session;
    
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:[NSUUID UUID].UUIDString];
    MCSession *session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionRequired];
    [peerID release];
    
    _session = [session retain];
    return [session autorelease];
}

- (MCAdvertiserAssistant *)advertiserAssistant {
    if (auto advertiserAssistant = _advertiserAssistant) return advertiserAssistant;
    
    MCAdvertiserAssistant *advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"ar-collab" discoveryInfo:nil session:self.session];
    
    _advertiserAssistant = [advertiserAssistant retain];
    return [advertiserAssistant autorelease];
}

@end
