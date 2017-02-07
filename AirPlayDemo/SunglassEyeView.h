//
//  SunglassEyeView.h
//  GooglyEyes
//
//  Created by Doan Phuong on 1/6/17.
//  Copyright © 2017 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunglassEyeView : UIView
@property (strong, nonatomic) UIImageView *imageView;


- (void)addSunglassImage;
- (void)rotateImageWithAngle:(CGFloat)degree;

@end
