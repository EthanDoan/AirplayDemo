//
//  ViewController.m
//  AirPlayDemo
//
//  Created by Doan Phuong on 2/6/17.
//  Copyright © 2017 Phuong Doan. All rights reserved.
//

#import "ViewController.h"
#import "TVViewController.h"

@interface ViewController ()
{
    UIWindow *tvWindow;
    UIScreen *tvScreen;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabletViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"TabletViewController"];
        
    [self checkForExistingScreenAndInitializeIfPresent];

}

- (void)checkForExistingScreenAndInitializeIfPresent
{
    if ([[UIScreen screens] count] > 1)
    {
        // Get the screen object that represents the external display.
        tvScreen = [[UIScreen screens] objectAtIndex:1];
        
        NSArray	*availableModes = [tvScreen availableModes];
        NSInteger selectedRow = [availableModes count] - 1;
        tvScreen.currentMode = [availableModes objectAtIndex:selectedRow];
        
        // Set a proper overscanCompensation mode
        tvScreen.overscanCompensation = UIScreenOverscanCompensationNone;
        
        // Get the screen's bounds so that you can create a window of the correct size.
        CGRect screenBounds = tvScreen.bounds;
        
        tvWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        tvWindow.screen = tvScreen;
        
        _tvViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"TVViewController"];
        
        tvWindow.rootViewController = _tvViewController;
        
        [_tvViewController playWebView];
        
        // Resize the view to fit the external screen        
        _tvViewController.view.frame = screenBounds;

        [tvWindow addSubview:_tvViewController.view];
        [tvWindow makeKeyAndVisible];
        
        // Show the window.
        tvWindow.hidden = NO;
        
        
        for (UIView* v in [self.view subviews])
            [v removeFromSuperview];

        //create UI on tablet
        [self.view addSubview:_tabletViewController.view];
        
    } else {
        NSLog(@"No external screen found");
        //create UI on tablet
//        [self.view addSubview:_tabletViewController.view];
//        _tabletViewController.view.frame = self.view.bounds;
    }
}

- (void)setUpScreenConnectionNotificationHandlers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
                   name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
                   name:UIScreenDidDisconnectNotification object:nil];
}

- (void)handleScreenDidConnectNotification:(NSNotification*)aNotification
{
    UIScreen *newScreen = [aNotification object];
    CGRect screenBounds = newScreen.bounds;
    
    if (!tvWindow)
    {
        tvWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        tvWindow.screen = newScreen;
        
        // Set the initial UI for the window.
    }
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification
{
    if (tvWindow)
    {
        // Hide and then delete the window.
        tvWindow.hidden = YES;
        tvWindow = nil;
        
    }
    
}

- (IBAction)playVideo:(UIButton *)sender {
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIScreenDidConnectNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIScreenDidDisconnectNotification
                                                  object:nil];
}



@end
