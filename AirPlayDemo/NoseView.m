//
//  NoseView.m
//  GooglyEyes
//
//  Created by Doan Phuong on 1/6/17.
//  Copyright © 2017 Google. All rights reserved.
//

#import "NoseView.h"


@interface NoseView()
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation NoseView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rednose"]];
    }
    return self;
}

- (void)addNoseImage {
    self.imageView.frame = self.bounds;
    [self addSubview:_imageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
