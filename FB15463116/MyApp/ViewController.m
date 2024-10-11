//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 10/12/24.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/message.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *canterStageEnabledSwitch;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureDeviceRotationCoordinator *rotationCoordinator;
@end

@implementation ViewController

- (void)dealloc {
    [_captureDevice removeObserver:self forKeyPath:@"isCenterStageActive"];
    [AVCaptureDevice removeObserver:self forKeyPath:@"isCenterStageEnabled"];
    [_rotationCoordinator removeObserver:self forKeyPath:@"videoRotationAngleForHorizonLevelPreview"];
    if (_captureSession.isRunning) {
        [_captureSession stopRunning];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.rotationCoordinator]) {
        if ([keyPath isEqualToString:@"videoRotationAngleForHorizonLevelPreview"]) {
            CGFloat value;
#if CGFLOAT_IS_DOUBLE
            value = ((NSNumber *)change[NSKeyValueChangeNewKey]).doubleValue;
#else
            Value = ((NSNumber *)change[NSKeyValueChangeNewKey]).floatValue;
#endif
            self.captureSession.connections[0].videoRotationAngle = value;
            return;
        }
    } else if ([object isEqual:self.captureDevice]) {
        if ([keyPath isEqualToString:@"isCenterStageActive"]) {
#warning Not Called!
            NSLog(@"Changed: %@ %@", object, keyPath);
            return;
        }
    } else if ([object isEqual:AVCaptureDevice.class]) {
        if ([keyPath isEqualToString:@"centerStageEnabled"]) {
            NSLog(@"Changed: %@ %@", object, keyPath);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.canterStageEnabledSwitch.on = AVCaptureDevice.isCenterStageEnabled;
            });
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the Center Stage supported capture device
    NSArray<AVCaptureDevice *> *captureDevices = ((id (*)(Class, SEL))objc_msgSend)(AVCaptureDeviceDiscoverySession.class, sel_registerName("allVideoDevices"));
    
    __block AVCaptureDevice *captureDevice = nil;
    
    for (AVCaptureDevice *_captureDevice in captureDevices) {
        [_captureDevice.formats enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AVCaptureDeviceFormat * _Nonnull format, NSUInteger idx, BOOL * _Nonnull stop) {
            if (format.centerStageSupported) {
                NSError * _Nullable error = nil;
                [_captureDevice lockForConfiguration:&error];
                assert(error == nil);
                _captureDevice.activeFormat = format;
                [_captureDevice unlockForConfiguration];
                
                captureDevice = _captureDevice;
                
                *stop = YES;
            }
        }];
    }
    
    assert(captureDevice != nil);
    self.captureDevice = captureDevice;
    
    [captureDevice addObserver:self forKeyPath:@"isCenterStageActive" options:NSKeyValueObservingOptionNew context:nil];
    [AVCaptureDevice addObserver:self forKeyPath:@"centerStageEnabled" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    // Setup Session
    AVCaptureSession *captureSession = [AVCaptureSession new];
    
    [captureSession beginConfiguration];
    
    NSError * _Nullable error = nil;
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    assert(error == nil);
    assert([captureSession canAddInput:deviceInput]);
    [captureSession addInput:deviceInput];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    previewLayer.zPosition = 0.;
    previewLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:previewLayer];
    self.canterStageEnabledSwitch.layer.zPosition = 1.;
    
    [captureSession commitConfiguration];
    
    self.captureSession = captureSession;
    
    AVCaptureDeviceRotationCoordinator *rotationCoordinator = [[AVCaptureDeviceRotationCoordinator alloc] initWithDevice:captureDevice previewLayer:previewLayer];
    self.rotationCoordinator = rotationCoordinator;
    [rotationCoordinator addObserver:self forKeyPath:@"videoRotationAngleForHorizonLevelPreview" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    AVCaptureDevice.centerStageControlMode = AVCaptureCenterStageControlModeCooperative;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [captureSession startRunning];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (__kindof CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:AVCaptureVideoPreviewLayer.class]) {
            layer.frame = self.view.layer.bounds;
            break;
        }
    }
}

- (IBAction)didToggleSwitch:(UISwitch *)sender {
    AVCaptureDevice.centerStageEnabled = sender.isOn;
}

@end
