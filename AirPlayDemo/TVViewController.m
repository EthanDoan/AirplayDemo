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
    
    NSString *string = @"http://m-stream.lizks.com/video360p/008o9d.mp4";
    NSURL *stringUrl = [NSURL URLWithString:string];

    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bakvendtland" ofType:@"mp4"];
    //NSURL *fileUrl = [NSURL URLWithString:filePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:stringUrl];
    _webView.mediaPlaybackAllowsAirPlay = YES;
    _webView.mediaPlaybackRequiresUserAction = NO;
    
    [_webView loadRequest:request];
}


- (void)mpMoviePlayerController {
    
    NSString *string = @"http://video.chiase.io:1935/366d6ba4-40c9-4870-9c78-80ad4222bfddvod/mp4:h264_videos/oyremz.mp4/playlist.m3u8";
    NSURL *stringUrl = [NSURL URLWithString:string];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Bakvendtland" ofType:@"mp4"];
//    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    
    _mpMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: stringUrl];
    [_mpMoviePlayer.view setFrame: self.view.bounds];
    [_mpMoviePlayer play];

    [self.view addSubview: _mpMoviePlayer.view];
    
    
}


@end
