//
//  ViewController.h
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVViewController.h"
#import "CaptureSession.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) TVViewController *tvViewController;
@property (weak, nonatomic) IBOutlet UIView *previewLayerView;
@property (weak, nonatomic) IBOutlet UIView *overlay;

@property (strong, nonatomic) CaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

