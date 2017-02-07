//
//  CheekView.m
//  GooglyEyes
//
//  Created by Doan Phuong on 1/8/17.
//  Copyright © 2017 Google. All rights reserved.
//

#import "CheekView.h"

@interface CheekView()
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CheekView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_heartpink"]];
    }
    return self;
}

- (void)addCheekImage {
    self.imageView.frame = self.bounds;
    [self addSubview:_imageView];
}




@end
