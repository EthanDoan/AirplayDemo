//
//  CaptureSession.m
//  CaptureSessionDemo
//
//  Created by Doan Phuong on 1/9/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import "CaptureSession.h"

@implementation CaptureSession

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionPreset = AVCaptureSessionPresetMedium;

    }
    return self;
}

- (void)addInputWithAVCaptureDevicePosition:(AVCaptureDevicePosition)position {
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([device position] == position) {
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                                error:&error];
            if (error) {
                NSLog(@"Could not initialize for AVMediaTypeVideo for device %@ with error %@", device, error.localizedDescription);
            } else {
                if ([self canAddInput:input]) {
                    [self addInput:input];
                } else {
                    NSLog(@"Cannot add input");
                }
            }
        }
    }
}

- (void)addAudioInput {
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput) {
        [self addInput:audioInput];
    } else {
        
    }
}

- (void)addOutput {
    //Output
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [self addOutput:output];
    output.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
}

@end
