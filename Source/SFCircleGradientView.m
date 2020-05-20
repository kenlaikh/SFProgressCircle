//
// SFCircleGradientView.m
//
// The MIT License (MIT)
// Copyright (c) 2016 SFÇD
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "SFCircleGradientView.h"
#import "SFCircleGradientLayer.h"

@implementation SFCircleGradientView
{
  SFCircleGradientLayer *_gradientLayer;
  SFCircleGradientLayer *_rimLayer;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self initView:[self frame]];
  }
  return self;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self initView:CGRectNull];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initView:frame];
  }
  return self;
}

- (void)initView:(CGRect)frame
{
  [self setBackgroundColor:[UIColor clearColor]];
  
  _gradientLayer = [SFCircleGradientLayer layer];
  _gradientLayer.contentsScale = [UIScreen mainScreen].scale;
  _gradientLayer.barColors = @[];
  _gradientLayer.barPositions = @[];
  
  _rimLayer = [SFCircleGradientLayer layer];
  _rimLayer.contentsScale = [UIScreen mainScreen].scale;
  _rimLayer.barColors = @[];
  _rimLayer.barPositions = @[];
  
  [self.layer addSublayer:_rimLayer];
  [self.layer addSublayer:_gradientLayer];
  
  [self updateLayerData:frame];
  
  self.progress = 1;
  self.lineWidth = 3;
}

- (void)setProgress:(CGFloat)progress
{
  _gradientLayer.progress = progress;
  _rimLayer.progress = 1.0;
  _rimLayer.startAngle = -M_PI_2 + 2 * M_PI * progress;
}

- (void)setLineWidth:(CGFloat)value
{
  _lineWidth = value;
  [self updateLayerData:self.frame];
}

- (void)setBarColors:(NSArray *)barColors
{
  _barColors = barColors;
  _gradientLayer.barColors = barColors;
}

- (void)setBarPositions:(NSArray *)barPositions
{
  _barPositions = barPositions;
  _gradientLayer.barPositions = barPositions;
}

- (void)setRimColors:(NSArray *)rimColors
{
  _rimColors = rimColors;
  _rimLayer.barColors = rimColors;
}

- (void)setRimPositions:(NSArray *)rimPositions
{
  _rimPositions = rimPositions;
  _rimLayer.barPositions = rimPositions;
}

- (void)setStartAngle:(CGFloat)startAngle
{
  _startAngle = startAngle;
  _gradientLayer.startAngle = startAngle;
  _rimLayer.startAngle = startAngle;
}

- (void)setEndAngle:(CGFloat)endAngle
{
  _endAngle = endAngle;
  _gradientLayer.endAngle = endAngle;
  _rimLayer.endAngle = endAngle;
}

- (void)setRoundedCorners:(BOOL)roundedCorners
{
  _roundedCorners = roundedCorners;
  _gradientLayer.roundedCorners = roundedCorners;
  _rimLayer.roundedCorners = roundedCorners;
}

- (void)updateLayerData:(CGRect)frame
{
  int numSegments = 16;
  CGFloat circleRadius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))/2;
  CGFloat circleWidth = _lineWidth;
  
  _gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
  _gradientLayer.numSegments = numSegments;
  _gradientLayer.circleRadius = circleRadius;
  _gradientLayer.circleWidth = circleWidth;
  
  _rimLayer.frame = CGRectMake(0, 0,  frame.size.width, frame.size.height);
  _rimLayer.numSegments = numSegments;
  _rimLayer.circleRadius = circleRadius;
  _rimLayer.circleWidth = circleWidth;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self updateLayerData:self.frame];
}

@end
