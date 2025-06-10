//
//  ViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 4/25/25.
//

#import "ViewController.h"
#include <dlfcn.h>
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewController ()
@property (retain, nonatomic, readonly, getter=_familyControlsConnection) NSXPCConnection *familyControlsConnection;
@property (retain, nonatomic, readonly, getter=_managedSettingsConnection) NSXPCConnection *managedSettingsConnection;
@end

@implementation ViewController

+ (void)load {
    assert(dlopen("/System/Library/Frameworks/FamilyControls.framework/FamilyControls", RTLD_NOW) != NULL);
    assert(dlopen("/System/Library/Frameworks/ManagedSettings.framework/ManagedSettings", RTLD_NOW) != NULL);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _familyControlsConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.FamilyControlsAgent", NSXPCConnectionPrivileged);
        _familyControlsConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP14FamilyControls19FamilyControlsAgent_")];
        _familyControlsConnection.interruptionHandler = ^{
            abort();
        };
        [_familyControlsConnection resume];
        
        _managedSettingsConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.ManagedSettingsAgent", NSXPCConnectionPrivileged);
        _managedSettingsConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"_TtP15ManagedSettings20ManagedSettingsAgent_")];
        _managedSettingsConnection.interruptionHandler = ^{
            abort();
        };
        [_managedSettingsConnection resume];
    }
    
    return self;
}

- (void)dealloc {
    [_familyControlsConnection invalidate];
    [_familyControlsConnection release];
    [_managedSettingsConnection invalidate];
    [_managedSettingsConnection release];
    [super dealloc];
}

- (void)loadView {
    UIButton *button = [UIButton new];
    
    UIAction *activateAction = [UIAction actionWithTitle:@"Activate" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, NSInteger, id)>(objc_msgSend)(_familyControlsConnection.remoteObjectProxy, sel_registerName("requestAuthorizationFor::"), 1, ^(NSNumber * _Nullable result, NSError * _Nullable error) {
            assert(error == nil);
            
            NSDictionary<NSString *, id> *values = @{
                @"account.lockAccounts": @YES,
                @"cellular.lockAppCellularData": @YES,
                @"cellular.lockCellularPlan": @YES,
                @"cellular.lockESIM": @YES,
                @"dateAndTime.requireAutomaticDateAndTime": @YES,
                @"passcode.lockPasscode": @YES,
                @"siri.denySiri": @YES,
                @"appStore.denyInAppPurchases": @YES,
                @"appStore.requirePasswordForPurchases": @YES,
                @"application.denyAppInstallation": @YES,
                @"application.denyAppRemoval": @YES,
                @"gameCenter.denyMultiplayerGaming": @YES,
                @"gameCenter.denyAddingFriends": @YES,
                @"media.denyExplicitContent": @YES,
                @"media.denyMusicService": @YES,
                @"media.denyBookstoreErotica": @YES,
                @"safari.denyAutoFill": @YES,
                @"appStore.maximumRating": @100,
                @"media.maximumMovieRating": @100,
                @"media.maximumTVShowRating": @100,
                @"safari.cookiePolicy": @"always"
            };
            
            reinterpret_cast<void (*)(id, SEL, id, id, id, id, id)>(objc_msgSend)(_managedSettingsConnection.remoteObjectProxy, sel_registerName("setValues:recordIdentifier:storeContainer:storeName:replyHandler:"), values, nil, NSBundle.mainBundle.bundleIdentifier, @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
                assert(error == nil);
            });
        });
    }];
    
    UIAction *deactivateAction = [UIAction actionWithTitle:@"Deactivate" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        reinterpret_cast<void (*)(id, SEL, id, id, id, id)>(objc_msgSend)(_managedSettingsConnection.remoteObjectProxy, sel_registerName("clearAllSettingsForRecordIdentifier:storeContainer:storeName:replyHandler:"), nil, NSBundle.mainBundle.bundleIdentifier, @"Test", ^(NSUUID * _Nullable recordIdentifier, NSError * _Nullable error) {
            assert(error == nil);
        });
    }];
    
    button.menu = [UIMenu menuWithChildren:@[activateAction, deactivateAction]];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    
    button.showsMenuAsPrimaryAction = YES;
    
    self.view = button;
    [button release];
}

@end
