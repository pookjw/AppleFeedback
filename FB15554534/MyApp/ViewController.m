//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 10/21/24.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/message.h>
#import <objc/runtime.h>

@interface ViewController ()
@property (retain, nonatomic, nullable) AVCaptureMultiCamSession *captureSession;
@end

@implementation ViewController

- (void)dealloc {
    [_captureSession stopRunning];
    [_captureSession release];
    [super dealloc];
}

- (void)viewIsAppearing:(BOOL)animated {
    [super viewIsAppearing:animated];
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        assert(granted);
    }];
    
    if (![AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        return;
    }
    
    assert(AVCaptureMultiCamSession.isMultiCamSupported);
    
    NSArray<AVCaptureDeviceType> *allVideoDeviceTypes = ((id (*)(Class, SEL))objc_msgSend)(AVCaptureDeviceDiscoverySession.class, sel_registerName("allVideoDeviceTypes"));
    
    AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:allVideoDeviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    
    NSArray<NSSet<AVCaptureDevice *> *> *supportedMultiCamDeviceSets = deviceDiscoverySession.supportedMultiCamDeviceSets;
    NSSet<AVCaptureDevice *> *multiCamDeviceSet = nil;
    for (NSSet<AVCaptureDevice *> *set in supportedMultiCamDeviceSets) {
        if (set.count > 1) {
            multiCamDeviceSet = set;
            break;
        }
    }
    assert(multiCamDeviceSet != nil);
    
    AVCaptureMultiCamSession *captureSession = [AVCaptureMultiCamSession new];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didReceiveRuntimeErrorNotification:) name:AVCaptureSessionRuntimeErrorNotification object:nil];
    
    [captureSession beginConfiguration];
    
    for (AVCaptureDevice *captureDevice in multiCamDeviceSet) {
        NSError * _Nullable error = nil;
        AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
        assert(error == nil);
        
        AVCaptureInputPort *videoInputPort = [deviceInput portsWithMediaType:AVMediaTypeVideo sourceDeviceType:nil sourceDevicePosition:AVCaptureDevicePositionUnspecified].firstObject;
        assert(videoInputPort != nil);
        
        NSString * _Nullable failureReason = nil;
        
        assert(((BOOL (*)(id, SEL, id, id *))objc_msgSend)(captureSession, sel_registerName("_canAddInput:failureReason:"), deviceInput, &failureReason));
        [captureSession addInputWithNoConnections:deviceInput];
        
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSessionWithNoConnection:captureSession];
        AVCaptureConnection *previewLayerConnection = [[AVCaptureConnection alloc] initWithInputPort:videoInputPort videoPreviewLayer:previewLayer];
        assert(((BOOL (*)(id, SEL, id, id *))objc_msgSend)(captureSession, sel_registerName("_canAddConnection:failureReason:"), previewLayerConnection, &failureReason));
        [captureSession addConnection:previewLayerConnection];
        [previewLayerConnection release];
        
        [self.view.layer addSublayer:previewLayer];
        previewLayer.frame = self.view.layer.bounds;
        previewLayer.opacity = 0.5f;
        [previewLayer release];
        
        AVCaptureMovieFileOutput *movileFileOutput = [AVCaptureMovieFileOutput new];
        assert(((BOOL (*)(id, SEL, id, id *))objc_msgSend)(captureSession, sel_registerName("_canAddOutput:failureReason:"), movileFileOutput, &failureReason));
        [captureSession addOutputWithNoConnections:movileFileOutput];
        
        AVCaptureConnection *deviceInputConnection = [[AVCaptureConnection alloc] initWithInputPorts:@[videoInputPort] output:movileFileOutput];
        assert(((BOOL (*)(id, SEL, id, id *))objc_msgSend)(captureSession, sel_registerName("_canAddConnection:failureReason:"), deviceInputConnection, &failureReason));
        [captureSession addConnection:deviceInputConnection];
        [deviceInputConnection release];
        
#warning README
        /* When I uncomment this code, the Video Preview Layer doesn't work. In another project, I encountered a runtime error: 'Error Domain=AVFoundationErrorDomain Code=-11819 "Cannot Complete Action" UserInfo={NSLocalizedDescription=Cannot Complete Action, NSLocalizedRecoverySuggestion=Try again later.}'.
         
         But for some reason, I don’t get any error in this project, yet the Video Preview Layer still doesn’t work. */
        
//        CMMetadataFormatDescriptionRef formatDescription;
//        assert(CMMetadataFormatDescriptionCreateWithMetadataSpecifications(kCFAllocatorDefault,
//                                                                           kCMMetadataFormatType_Boxed,
//                                                                           (CFArrayRef)@[
//            @{
//                (id)kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier: AVMetadataIdentifierQuickTimeMetadataLocationISO6709,
//                (id)kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType: (id)kCMMetadataDataType_QuickTimeMetadataLocation_ISO6709
//            }
//        ],
//                                                                           &formatDescription) == 0);
//        
//        AVCaptureMetadataInput *metadataInput = [[AVCaptureMetadataInput alloc] initWithFormatDescription:formatDescription clock:CMClockGetHostTimeClock()];
//        [deviceInput release];
//        CFRelease(formatDescription);
//        
//        assert(((BOOL (*)(id, SEL, id, id *))objc_msgSend)(captureSession, sel_registerName("_canAddInput:failureReason:"), metadataInput, &failureReason));
//        [captureSession addInputWithNoConnections:metadataInput];
//        
//        AVCaptureInputPort *metadataInputPort = nil;
//        for (AVCaptureInputPort *inputPort in metadataInput.ports) {
//            if ([inputPort.mediaType isEqualToString:AVMediaTypeMetadata]) {
//                metadataInputPort = inputPort;
//                break;
//            }
//        }
//        assert(metadataInputPort != nil);
//        
//        AVCaptureConnection *metadataInputConnection = [[AVCaptureConnection alloc] initWithInputPorts:@[metadataInputPort] output:movileFileOutput];
//        [metadataInput release];
//        
//        assert(((BOOL (*)(id, SEL, id, id *))objc_msgSend)(captureSession, sel_registerName("_canAddConnection:failureReason:"), metadataInputConnection, &failureReason));
//        [captureSession addConnection:metadataInputConnection];
//        [metadataInputConnection release];
        
        
        
        [movileFileOutput release];
    }
    
    [captureSession commitConfiguration];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [captureSession startRunning];
    });
    
    self.captureSession = captureSession;
    [captureSession release];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (__kindof CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:AVCaptureVideoPreviewLayer.class]) {
            layer.frame = self.view.layer.bounds;
        }
    }
}

- (void)didReceiveRuntimeErrorNotification:(NSNotification *)notification {
    NSLog(@"%@", notification);
}

@end
