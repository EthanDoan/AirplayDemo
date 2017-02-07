//
//  TabletViewController.m
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import "TabletViewController.h"

@interface TabletViewController ()

@end

@implementation TabletViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_session startRunning];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    _session = [[CaptureSession alloc] init];
    [_session addInputWithAVCaptureDevicePosition:AVCaptureDevicePositionFront]; //video input
    [_session addAudioInput]; //audio input
    //    [_session addOutput]; //output
    
    //preview player
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.frame = _previewLayerView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    CALayer *rootLayer = [self.previewLayerView layer];
    [_previewLayer setFrame:rootLayer.bounds];
    [rootLayer addSublayer:_previewLayer];
    
    
}



@end
