//
//  ViewController.m
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import "ViewController.h"
#import "TVViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FaceTracker.h"

@import GoogleMVDataOutput;
@import GoogleMobileVision;

@interface ViewController () <GMVDataOutputDelegate, GMVMultiDataOutputDelegate, FaceTrackerDataSource>
{
    UIWindow *tvWindow;
    UIScreen *tvScreen;
}

@property (strong, nonatomic) GMVDataOutput *dataOutput;

@end

@implementation ViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //start capture session
    [_session startRunning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self cleanupCaptureSession];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _session = [[CaptureSession alloc] init];
    [_session addInputWithAVCaptureDevicePosition:AVCaptureDevicePositionFront]; //video input
    [_session addAudioInput]; //audio input
    //    [_session addOutput]; //output
    
    // Set up processing pipeline.
    [self setupGMVDataOutput];
    
    //preview player
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.frame = _previewLayerView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    CALayer *rootLayer = [self.previewLayerView layer];
    [_previewLayer setFrame:rootLayer.bounds];
    [rootLayer addSublayer:_previewLayer];

    [self checkForExistingScreenAndInitializeIfPresent];
    
}

#pragma mark - GMV Pipeline Setup

- (void)setupGMVDataOutput {
    NSDictionary *options = @{
                              GMVDetectorFaceTrackingEnabled : @(YES),
                              GMVDetectorFaceMode : @(GMVDetectorFaceFastMode),
                              GMVDetectorFaceLandmarkType : @(GMVDetectorFaceLandmarkAll),
                              GMVDetectorFaceClassificationType : @(GMVDetectorFaceClassificationAll),
                              GMVDetectorFaceMinSize : @0.1
                              };
    GMVDetector *detector = [GMVDetector detectorOfType:GMVDetectorTypeFace options:options];
    
    self.dataOutput = [[GMVMultiDataOutput alloc] initWithDetector:detector];
    FaceTracker *tracker = [[FaceTracker alloc] init];
    tracker.delegate = self;
    ((GMVMultiDataOutput *)self.dataOutput).multiDataDelegate = self;
    
    if (![self.session canAddOutput:self.dataOutput]) {
        [self cleanupGMVDataOutput];
        NSLog(@"Failed to setup video output");
        return;
    }
    
    //    [self outputSetting];
    [self.session addOutput:self.dataOutput];
}


- (void)cleanupGMVDataOutput {
    if (self.dataOutput) {
        [self.session removeOutput:self.dataOutput];
    }
    [self.dataOutput cleanup];
    self.dataOutput = nil;
}

- (void)cleanupCaptureSession {
    [self.session stopRunning];
    [self cleanupGMVDataOutput];
    self.session = nil;
    [self.previewLayer removeFromSuperlayer];
}


- (void)sessionRemoveOldInput {
    NSArray *array = _session.inputs;
    for (AVCaptureInput *oldInput in array) {
        [_session removeInput:oldInput];
    }
}


#pragma mark - FaceTrackerDatasource

//view that contain goodlyeyes
- (UIView *)overlayView {
    return self.overlay;
}

- (CGFloat)xScale {
    return self.dataOutput.xScale;
}

- (CGFloat)yScale {
    return self.dataOutput.yScale;
}

- (CGPoint)offset {
    return self.dataOutput.offset;
}

- (UIView *)superView {
    return self.view;
}


#pragma mark - GMVMultiDataOutputDelegate

- (id<GMVOutputTrackerDelegate>)dataOutput:(GMVDataOutput *)dataOutput
                         trackerForFeature:(GMVFeature *)feature {
    FaceTracker *tracker = [[FaceTracker alloc] init];
    tracker.delegate = self;
    return tracker;
}






- (void)checkForExistingScreenAndInitializeIfPresent
{
    if ([[UIScreen screens] count] > 1)
    {
        // Get the screen object that represents the external display.
        tvScreen = [[UIScreen screens] objectAtIndex:1];
        
        NSArray	*availableModes = [tvScreen availableModes];
        NSInteger selectedRow = [availableModes count] - 1;
        tvScreen.currentMode = [availableModes objectAtIndex:selectedRow];
        
        // Set a proper overscanCompensation mode
        tvScreen.overscanCompensation = UIScreenOverscanCompensationNone;
        
        // Get the screen's bounds so that you can create a window of the correct size.
        CGRect screenBounds = tvScreen.bounds;
        
        tvWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        tvWindow.screen = tvScreen;
        
        _tvViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"TVViewController"];
        
        tvWindow.rootViewController = _tvViewController;
                
        // Resize the view to fit the external screen        
        _tvViewController.view.frame = screenBounds;

        [tvWindow addSubview:_tvViewController.view];
        [tvWindow makeKeyAndVisible];
        
        // Show the window.
        tvWindow.hidden = NO;
        
        
//        for (UIView* v in [self.view subviews])
//            [v removeFromSuperview];
//
//        //create UI on tablet
//        [self.view addSubview:_tabletViewController.view];
        
    } else {
        NSLog(@"No external screen found");

    }
}

- (void)setUpScreenConnectionNotificationHandlers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
                   name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
                   name:UIScreenDidDisconnectNotification object:nil];
}

- (void)handleScreenDidConnectNotification:(NSNotification*)aNotification
{
    UIScreen *newScreen = [aNotification object];
    CGRect screenBounds = newScreen.bounds;
    
    if (!tvWindow)
    {
        tvWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        tvWindow.screen = newScreen;
        
        // Set the initial UI for the window.
    }
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification
{
    if (tvWindow)
    {
        // Hide and then delete the window.
        tvWindow.hidden = YES;
        tvWindow = nil;
        
    }
    
}

- (IBAction)playVideo:(UIButton *)sender {
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIScreenDidConnectNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIScreenDidDisconnectNotification
                                                  object:nil];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.previewLayer.frame = self.view.layer.bounds;
    self.previewLayer.position = CGPointMake(CGRectGetMidX(self.previewLayer.frame),
                                             CGRectGetMidY(self.previewLayer.frame));
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Camera rotation needs to be manually set when rotation changes.
    if (self.previewLayer) {
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        } else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        }
    }
    self.dataOutput.previewFrameSize = self.previewLayer.frame.size;
}





@end
