//
//  ViewController.h
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVViewController.h"
#import "TabletViewController.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) TVViewController *tvViewController;
@property (nonatomic, strong) TabletViewController *tabletViewController;

@end

