//
//  SunglassEyeView.m
//  GooglyEyes
//
//  Created by Doan Phuong on 1/6/17.
//  Copyright © 2017 Google. All rights reserved.
//

#import "SunglassEyeView.h"

@interface SunglassEyeView()

@end

@implementation SunglassEyeView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sunglass"]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_imageView];
    }
    return self;
}


- (void)addSunglassImage {
    self.imageView.frame = self.bounds;
}

- (void)rotateImageWithAngle:(CGFloat)degree {
    self.transform = CGAffineTransformMakeRotation(degree * M_PI/180);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
