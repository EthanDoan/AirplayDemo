//
//  TVViewController.m
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import "TVViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TVViewController ()
{
    BOOL firstPlay;
}
@property (strong, nonatomic) MPMoviePlayerController *mpMoviePlayer;

@end

@implementation TVViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (firstPlay) {
        
        //use MPMoviePlayerController to play video
        [self mpMoviePlayerController];
        
        //use UIWebView to play Video
//        [self playWebView];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    firstPlay = YES;
    

}

- (void)playWebView {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bakvendtland" ofType:@"mp4"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    _webView.mediaPlaybackAllowsAirPlay = YES;
    _webView.mediaPlaybackRequiresUserAction = NO;
    
    [_webView loadRequest:request];
}


- (void)mpMoviePlayerController {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bakvendtland" ofType:@"mp4"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    _mpMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileUrl];
    [_mpMoviePlayer.view setFrame: self.view.bounds];
    [_mpMoviePlayer play];

    [self.view addSubview: _mpMoviePlayer.view];
    
    
}


@end
