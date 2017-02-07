//
//  FaceTracker.h
//  CaptureSessionDemo
//
//  Created by Doan Phuong on 1/10/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMVDataOutput;

// The data source provides the FaceTracker object with the information it needs to display
// superimposed googly eyes.
@protocol FaceTrackerDataSource <NSObject>

// Display scaling offset.
- (CGFloat)xScale;
- (CGFloat)yScale;
- (CGPoint)offset;

// View to display.
- (UIView *)overlayView;
- (UIView *)superView;

@end

// Manages GooglyEyeViews. This class implements GMVOutputTrackerDelegate to receive
// face and landmarks tracking notifications. It updates the GooglyEyeViews' positions and
// sizes accordingly.
@interface FaceTracker : NSObject <GMVOutputTrackerDelegate>

@property (nonatomic, weak) id <FaceTrackerDataSource> delegate;

@end
