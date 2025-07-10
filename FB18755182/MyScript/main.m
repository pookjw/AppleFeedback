//
//  main.m
//  MyScript
//
//  Created by Jinwoo Kim on 7/11/25.
//

#import <AVFoundation/AVFoundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        AVCaptureSession *session = [AVCaptureSession new];
        
        AVCaptureVideoPreviewLayer *layer_1 = [[AVCaptureVideoPreviewLayer alloc] initWithSessionWithNoConnection:session];
        layer_1.deferredStartEnabled = YES;
        assert(layer_1.deferredStartEnabled);
        
        AVCaptureVideoPreviewLayer *layer_2 = [[AVCaptureVideoPreviewLayer alloc] initWithLayer:layer_1];
        assert(layer_2.deferredStartEnabled); // Fails
    }
    return EXIT_SUCCESS;
}
