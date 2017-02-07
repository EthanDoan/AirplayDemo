//
//  CaptureSession.h
//  CaptureSessionDemo
//
//  Created by Doan Phuong on 1/9/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface CaptureSession : AVCaptureSession

- (void)addInputWithAVCaptureDevicePosition:(AVCaptureDevicePosition)position;
- (void)addOutput;
- (void)addAudioInput;

@end
