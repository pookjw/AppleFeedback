//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 6/12/25.
//

#import "ViewController.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface ViewController ()
@property (retain, nonatomic, nullable, getter=_slider, setter=_setSlider:) UISlider *slider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISlider *slider = [UISlider new];
    slider.frame = self.view.bounds;
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:slider];
    self.slider = slider;
    [slider release];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:[self _makeMenu]];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
}

- (UIMenu *)_makeMenu __attribute__((objc_direct)) {
    UISlider *slider = self.slider;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        if (slider.trackConfiguration == nil) {
            UIAction *action = [UIAction actionWithTitle:@"Set Track Configuration" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                slider.trackConfiguration = [UISliderTrackConfiguration configurationWithNumberOfTicks:30];
                
                // Uncomment to fix
//                __kindof UIView *_visualElement;
//                assert(object_getInstanceVariable(slider, "_visualElement", (void **)&_visualElement) != NULL);
//                _visualElement.frame = _visualElement.frame;
            }];
            completion(@[action]);
        } else {
            UIAction *action = [UIAction actionWithTitle:@"Remove Track Configuration" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                float value = slider.value;
                
                slider.trackConfiguration = nil;
                
                // Uncomment to fix
                ((void (*)(id ,SEL, float))objc_msgSend)(slider, sel_registerName("_setMinimumEnabledValue:"), slider.minimumValue);
                ((void (*)(id ,SEL, float))objc_msgSend)(slider, sel_registerName("_setMaximumEnabledValue:"), slider.maximumValue);
                slider.value = value;
                __kindof UIView *_visualElement;
                assert(object_getInstanceVariable(slider, "_visualElement", (void **)&_visualElement) != NULL);
                _visualElement.frame = _visualElement.frame;
            }];
            
            action.attributes = UIMenuElementAttributesDestructive;
            completion(@[action]);
        }
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}


@end
