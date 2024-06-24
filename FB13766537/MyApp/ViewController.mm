//
//  ViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 5/1/24.
//

#import "ViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface MySlider : UISlider
@end

@implementation MySlider

- (void)dealloc {
    abort(); // Never Called
    [super dealloc];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAction *requestSceneAction = [UIAction actionWithTitle:@"Request Scene" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        UISceneSessionActivationRequest *request = [UISceneSessionActivationRequest requestWithRole:UIWindowSceneSessionRoleApplication];
        [UIApplication.sharedApplication activateSceneSessionForRequest:request errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:requestSceneAction];
    
    MySlider *slider = [MySlider new];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[button, slider]];
    [slider release];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
    
    [stackView release];
}

@end
