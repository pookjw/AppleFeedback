//
//  ViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 7/7/25.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#include <objc/message.h>
#include <objc/runtime.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    NSArray<NSString *> *allVideoDeviceTypes = ((id (*)(Class, SEL))objc_msgSend)([AVCaptureDeviceDiscoverySession class], sel_registerName("allVideoDeviceTypes"));
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:allVideoDeviceTypes
                                                                                                               mediaType:AVMediaTypeDepthData
                                                                                                                position:AVCaptureDevicePositionUnspecified];
    
    AVCaptureDevice *videoDevice;
    for (AVCaptureDevice *_device in discoverySession.devices) {
        for (AVCaptureDeviceFormat *format in _device.formats) {
            if (format.cinematicVideoCaptureSupported) {
                videoDevice = _device;
                break;
            }
        }
        if (videoDevice != nil) break;
    }
    assert(videoDevice != nil);
    
    /*
     iPhone 16 Pro Max
     <AVCaptureFigVideoDevice: 0x107735800 [Back Dual Wide Camera][com.apple.avfoundation.avcapturedevice.built-in_video:6]>
     */
    NSLog(@"%@", videoDevice);
    
    NSError * _Nullable error = nil;
    [videoDevice lockForConfiguration:&error];
    assert(error == nil);
    for (AVCaptureDeviceFormat *format in videoDevice.formats) {
        if (format.cinematicVideoCaptureSupported) {
            videoDevice.activeFormat = format;
            break;
        }
    }
    [videoDevice unlockForConfiguration];
    
    
    [session beginConfiguration];
    
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:&error];
    assert(input != nil);
    assert([session canAddInput:input]);
    [session addInput:input];
    
    CMMetadataFormatDescriptionRef formatDescription;
    assert(CMMetadataFormatDescriptionCreateWithMetadataSpecifications(kCFAllocatorDefault,
                                                                       kCMMetadataFormatType_Boxed,
                                                                       (__bridge CFArrayRef)@[
        @{
            (id)kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier: AVMetadataIdentifierQuickTimeMetadataDetectedFace,
            (id)kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType: (id)kCMMetadataBaseDataType_RectF32
        },
        @{
            (id)kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier: AVMetadataIdentifierQuickTimeMetadataLocationISO6709,
            (id)kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType: (id)kCMMetadataDataType_QuickTimeMetadataLocation_ISO6709
        }
    ],
                                                                       &formatDescription) == 0);
    
    AVCaptureInputPort *port = [input portsWithMediaType:AVMediaTypeVideo sourceDeviceType:nil sourceDevicePosition:AVCaptureDevicePositionUnspecified].firstObject;
    AVCaptureInputPort *depthDataInputPort = [input portsWithMediaType:AVMediaTypeDepthData sourceDeviceType:nil sourceDevicePosition:AVCaptureDevicePositionUnspecified].firstObject;
    assert(depthDataInputPort != nil);
    
    AVCaptureDepthDataOutput *output = [[AVCaptureDepthDataOutput alloc] init];
    assert([session canAddOutput:output]);
    [session addOutputWithNoConnections:output];
    AVCaptureConnection *connection = [[AVCaptureConnection alloc] initWithInputPorts:@[depthDataInputPort] output:output];
    assert([session canAddConnection:connection]);
    [session addConnection:connection];
    
    AVCaptureMetadataInput *metadataInput = [[AVCaptureMetadataInput alloc] initWithFormatDescription:formatDescription clock:port.clock];
    assert([session canAddInput:metadataInput]);
    [session addInput:metadataInput];
    
    [session commitConfiguration];
}

@end
