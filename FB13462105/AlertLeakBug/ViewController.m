//
//  ViewController.m
//  AlertLeakBug
//
//  Created by Jinwoo Kim on 12/12/23.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak ViewController *weakSelf = self;
    
    UIAction *presentAlertAction = [UIAction actionWithTitle:@"Present Alert" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hello World!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:doneAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
    
    UIButton *presentAlertButton = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:presentAlertAction];
    
    //
    
    UIWindowSceneActivationAction *sceneActivationAction = [UIWindowSceneActivationAction actionWithIdentifier:nil alternateAction:nil configurationProvider:^UIWindowSceneActivationConfiguration * _Nullable(__kindof UIWindowSceneActivationAction * _Nonnull action) {
        return [[UIWindowSceneActivationConfiguration alloc] initWithUserActivity:[[NSUserActivity alloc] initWithActivityType:@"Test"]];
    }];
    
    UIButton *sceneActivationButton = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:sceneActivationAction];
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:self.view.bounds];
    [stackView addArrangedSubview:presentAlertButton];
    [stackView addArrangedSubview:sceneActivationButton];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:stackView];
}

@end
