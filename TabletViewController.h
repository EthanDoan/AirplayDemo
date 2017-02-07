//
//  TabletViewController.h
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSession.h"

@interface TabletViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *previewLayerView;

@property (strong, nonatomic) CaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (strong, nonatomic) AVAssetWriter *assetWriter;

@end
