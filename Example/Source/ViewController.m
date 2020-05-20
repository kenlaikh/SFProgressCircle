//
//  ViewController.m
//  Example
//
//  Created by Sibagatov Ildar on 21/07/16.
//  Copyright © 2016 SFÇD. All rights reserved.
//

#import "ViewController.h"
#import <SFProgressCircle/SFProgressCircle.h>

#define AnimationDuration 0.6

@interface ViewController ()
{
}
@property (nonatomic) SFCircleGradientView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  _progressView = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, 200, 200}];
  [_progressView setCenter:self.view.center];
  [_progressView setLineWidth:10];
  [_progressView setProgress:0.75];
  [_progressView setRoundedCorners:YES];
  NSArray *barColors = [NSArray arrayWithObjects:[UIColor colorWithRed:46/255.0 green:49/255.0 blue:146/255.0 alpha:1], [UIColor colorWithRed:102/255.0 green:45/255.0 blue:145/255.0 alpha:1], [UIColor colorWithRed:190/255.0 green:129/255.0 blue:239/255.0 alpha:1], nil];
  
  NSArray *barPositions = [NSArray arrayWithObjects:@(0), @(0.75), @(1), nil];
  
  [_progressView setBarColors:barColors];
  [_progressView setBarPositions:barPositions];
  
  NSArray *rimColors = [NSArray arrayWithObjects:[UIColor colorWithRed:33/255.0 green:34/255.0 blue:41/255.0 alpha:1], [UIColor colorWithRed:48/255.0 green:49/255.0 blue:59/255.0 alpha:1], nil];
  
  NSArray *rimPositions = [NSArray arrayWithObjects:@(0), @(1), nil];
  
  [_progressView setRimColors:rimColors];
  [_progressView setRimPositions:rimPositions];
  [self.view addSubview:_progressView];
  
  self.view.backgroundColor = [UIColor colorWithRed:48/255.0 green:49/255.0 blue:59/255.0 alpha:1.0];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleDefault;
}

@end
