//
//  FaceTracker.m
//  CaptureSessionDemo
//
//  Created by Doan Phuong on 1/10/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import "FaceTracker.h"
#import "NoseView.h"
#import "CheekView.h"
#import "SunglassEyeView.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface FaceTracker()

@property (nonatomic, assign) CGPoint lastNosePosition;
@property (nonatomic, assign) CGPoint lastCheekPosition;
@property (nonatomic, assign) CGPoint midPosition;
@property (nonatomic, assign) CGPoint lastMiddleEyePosition;

@property (nonatomic, strong) NoseView *noseView;
@property (nonatomic, strong) SunglassEyeView *sunglassView;
@property (nonatomic, strong) CheekView *cheekView;

@end

@implementation FaceTracker

#pragma mark - GMVOutputTrackerDelegate

- (void)dataOutput:(GMVDataOutput *)dataOutput detectedFeature:(GMVFeature *)feature {
    self.noseView = [[NoseView alloc] init];
    self.sunglassView = [[SunglassEyeView alloc] init];
    self.cheekView = [[CheekView alloc] init];
    [[self.delegate overlayView] addSubview:_noseView];
    [[self.delegate overlayView] addSubview:_sunglassView];
    [[self.delegate overlayView] addSubview:_cheekView];
}

- (void)dataOutput:(GMVDataOutput *)dataOutput
updateFocusingFeature:(GMVFaceFeature *)face
      forResultSet:(NSArray<GMVFaceFeature *> *)features {
    self.noseView.hidden = NO;
    self.sunglassView.hidden = NO;
    self.cheekView.hidden = NO;
    
    //nose view
    CGPoint nosePosition = face.hasNoseBasePosition ? face.noseBasePosition : CGPointZero;
    CGRect noseRect = [self noseRect:_lastNosePosition newNosePosition:nosePosition faceRect:face.bounds];
    _noseView.frame = noseRect;
    [_noseView addNoseImage];
    
    //cheek view
    CGPoint cheekPosition = face.hasLeftCheekPosition ? face.leftCheekPosition : CGPointZero;
    CGRect cheekRect = [self cheekRect:_lastCheekPosition newCheekPosition:cheekPosition faceRect:face.bounds];
    _cheekView.frame = cheekRect;
    [_cheekView addCheekImage];
    
    //sunglassview
    CGFloat leftEyeY = face.leftEyePosition.y;
    CGFloat rightEyeY = face.rightEyePosition.y;
    CGPoint midPoint = CGPointMake(ABS((face.rightEyePosition.x - face.leftEyePosition.x) / 2), ABS((leftEyeY - rightEyeY) / 2));
    _midPosition = CGPointMake(face.leftEyePosition.x + midPoint.x, rightEyeY + midPoint.y);
    CGRect sunglassRect = [self sunglassRect:self.lastMiddleEyePosition
                         newSunglassPosition:_midPosition
                                    faceRect:face.bounds];
    _sunglassView.frame = sunglassRect;
    [_sunglassView addSunglassImage];
    
    float degrees = [self pointPairToBearingDegrees:face.leftEyePosition secondPoint:face.rightEyePosition];
    [_sunglassView rotateImageWithAngle:degrees];
    _sunglassView.bounds = CGRectMake(0, 0, sunglassRect.size.width, sunglassRect.size.height);
    _sunglassView.imageView.bounds = _sunglassView.bounds;
    
    // Remember last known eyes positions.
    [self updateLastFaceFeature:face];
    
    [self convertViewToImage];
    
    
    
    
}

- (void)dataOutput:(GMVDataOutput *)dataOutput
updateMissingFeatures:(NSArray<GMVFaceFeature *> *)features {
    self.noseView.hidden = YES;
    self.sunglassView.hidden = YES;
    self.cheekView.hidden = YES;
}

- (void)dataOutputCompletedWithFocusingFeature:(GMVDataOutput *)dataOutput{
    [self.noseView removeFromSuperview];
    [self.sunglassView removeFromSuperview];
    [self.cheekView removeFromSuperview];
    
}

#pragma mark - Helper methods

- (CGRect)scaledRect:(CGRect)rect
              xScale:(CGFloat)xscale
              yScale:(CGFloat)yscale
              offset:(CGPoint)offset {
    
    CGRect resultRect = CGRectMake(floor(rect.origin.x * xscale),
                                   floor(rect.origin.y * yscale),
                                   floor(rect.size.width * xscale),
                                   floor(rect.size.height * yscale));
    resultRect = CGRectOffset(resultRect, offset.x, offset.y);
    return resultRect;
}

- (CGRect)noseRect:(CGPoint)lastNosePosition
   newNosePosition:(CGPoint)newNosePosition
          faceRect:(CGRect)faceRect {
    CGPoint eye = lastNosePosition;
    if (!CGPointEqualToPoint(newNosePosition, CGPointZero)) {
        eye = newNosePosition;
    }
    
    CGFloat faceToEyeRatio = 6.0;
    CGFloat width = faceRect.size.width / faceToEyeRatio;
    CGRect rect = CGRectMake(eye.x - width / 2,
                             eye.y - width / 2,
                             width,
                             width);
    rect = [self scaledRect:rect
                     xScale:[self.delegate xScale]
                     yScale:[self.delegate yScale]
                     offset:[self.delegate offset]];
    return rect;
}

- (CGRect)cheekRect:(CGPoint)lastPosition
   newCheekPosition:(CGPoint)newPosition
           faceRect:(CGRect)faceRect {
    CGPoint eye = lastPosition;
    if (!CGPointEqualToPoint(newPosition, CGPointZero)) {
        eye = newPosition;
    }
    
    CGFloat faceToEyeRatio = 12.0;
    CGFloat width = faceRect.size.width / faceToEyeRatio;
    CGRect rect = CGRectMake(eye.x - width / 2,
                             eye.y - width / 2,
                             width,
                             width);
    rect = [self scaledRect:rect
                     xScale:[self.delegate xScale]
                     yScale:[self.delegate yScale]
                     offset:[self.delegate offset]];
    return rect;
}


- (CGRect)sunglassRect:(CGPoint)lastSunglassPosition
   newSunglassPosition:(CGPoint)newSunglassPosition
              faceRect:(CGRect)faceRect {
    CGPoint eye = lastSunglassPosition;
    if (!CGPointEqualToPoint(newSunglassPosition, CGPointZero)) {
        eye = newSunglassPosition;
    }
    
    CGFloat faceToEyeRatio = 4.0;
    CGFloat width = faceRect.size.width / faceToEyeRatio;
    CGRect rect = CGRectMake(eye.x - width,
                             eye.y - width / 2,
                             width * 2,
                             width);
    rect = [self scaledRect:rect
                     xScale:[self.delegate xScale]
                     yScale:[self.delegate yScale]
                     offset:[self.delegate offset]];
    return rect;
}

- (CGFloat)pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}


- (void)updateLastFaceFeature:(GMVFaceFeature *)feature {
    if (feature.hasNoseBasePosition) {
        self.lastNosePosition = feature.noseBasePosition;
    }
    if (feature.hasLeftEyePosition && feature.hasRightEyePosition) {
        self.lastMiddleEyePosition = self.midPosition;
    }
    if (feature.hasLeftCheekPosition) {
        self.lastCheekPosition = feature.leftCheekPosition;
    }
}

- (UIImage *)convertViewToImage {
    UIGraphicsBeginImageContext([self.delegate superView].bounds.size);
    [[self.delegate superView] drawViewHierarchyInRect:[self.delegate superView].bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
