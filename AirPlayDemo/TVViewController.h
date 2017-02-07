//
//  TVViewController.h
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TVViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *link;

- (void)playWebView;
@end
