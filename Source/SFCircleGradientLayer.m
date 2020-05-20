//
// SFCircleGradientLayer.m
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

#import "SFCircleGradientLayer.h"

@implementation SFCircleGradientLayer

- (id)init
{
  if (self = [super init])  {
    self.startAngle = -M_PI_2;
    self.endAngle = 2 * M_PI - M_PI_2;
  }
  return self;
}

- (id)initWithLayer:(id)param
{
  if (self = [super initWithLayer:param])  {
    SFCircleGradientLayer *layer = (SFCircleGradientLayer*)param;
    self.progress = layer.progress;
    self.maxProgress = layer.maxProgress;
    self.barColors = layer.barColors;
    self.barPositions = layer.barPositions;
    self.startAngle = layer.startAngle;
    self.endAngle = layer.endAngle;
    self.numSegments = layer.numSegments;
    self.circleRadius = layer.circleRadius;
    self.circleWidth = layer.circleWidth;
    self.roundedCorners = layer.roundedCorners;
  }
  return self;
}

- (void)setNumSegments:(int)numSegments
{
  _numSegments = MAX(2, numSegments);
  [self setNeedsDisplay];
}

- (void)setCircleRadius:(CGFloat)circleRadius
{
  _circleRadius = circleRadius;
  [self setNeedsDisplay];
}

- (void)setCircleWidth:(CGFloat)circleWidth
{
  _circleWidth = circleWidth;
  [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
  _progress = MAX(0, progress);
  [self setNeedsDisplay];
}

- (void)setMaxProgress:(CGFloat)maxProgress
{
  _maxProgress = MAX(0, maxProgress);
  [self setNeedsDisplay];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
  if ([key isEqualToString:@"barColors"]) {
    return YES;
  }
  if ([key isEqualToString:@"barPositions"]) {
    return YES;
  }
  if ([key isEqualToString:@"startAngle"]) {
    return YES;
  }
  if ([key isEqualToString:@"endAngle"]) {
    return YES;
  }
  if ([key isEqualToString:@"progress"]) {
    return YES;
  }
  if ([key isEqualToString:@"maxProgress"]) {
    return YES;
  }
  return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
  [super drawInContext:ctx];
  [self drawWithSegmentNumber:_numSegments context:ctx];
}

- (void)drawWithSegmentNumber:(int)segmentCount context:(CGContextRef)ctx
{
  CGFloat durationAngle = (self.endAngle - self.startAngle) * (self.progress / self.maxProgress);
  if (_circleRadius * durationAngle < 0.001) {
    return;
  }
  CGRect bounds = self.bounds;
  CGPoint centerPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
  
  CGFloat startAngle = self.barPositions.count > 0 ? self.startAngle + durationAngle * [self.barPositions[0] floatValue] : 0;
  CGFloat endAngle = self.barPositions.count > 1 ? self.startAngle + durationAngle * [self.barPositions[1] floatValue] : 360;
  
  for (int i = 1; i < self.barColors.count; i++) {
    CGFloat c1[4];
    CGFloat c2[4];
    [self.barColors[i-1] getRed:&c1[0] green:&c1[1] blue:&c1[2] alpha:&c1[3]];
    [self.barColors[i] getRed:&c2[0] green:&c2[1] blue:&c2[2] alpha:&c2[3]];
    
    UIColor *fromColor = self.barColors[i-1];
    for(int j = 0; j < segmentCount / (self.barColors.count - 1); ++j)
    {
      CGFloat f_cur = (CGFloat)(j) / (segmentCount / (self.barColors.count - 1));
      CGFloat f = (CGFloat)(j + 1) / (segmentCount / (self.barColors.count - 1));
      
      UIColor *toColor = [UIColor colorWithRed:f * c2[0] + (1 - f) * c1[0]
                                         green:f * c2[1] + (1 - f) * c1[1]
                                          blue:f * c2[2] + (1 - f) * c1[2]
                                         alpha:f * c2[3] + (1 - f) * c1[3]];
      
      CGFloat fromAngleCur = startAngle + f_cur * (endAngle - startAngle);
      CGFloat toAngleCur = startAngle + f * (endAngle - startAngle);
      [self drawSegmentAtCenter:centerPoint from:fromAngleCur to:toAngleCur radius:_circleRadius width:_circleWidth
                     startColor:fromColor endColor:toColor context:ctx];
      
      fromColor = toColor;
    }
    
    startAngle = endAngle;
    endAngle = self.startAngle + (i + 1 < self.barPositions.count ? durationAngle * [self.barPositions[i + 1] floatValue] : 0);
  }
}

- (void)drawSegmentAtCenter:(CGPoint)center
                       from:(CGFloat)startAngle
                         to:(CGFloat)endAngle
                     radius:(CGFloat)radius
                      width:(CGFloat)width
                 startColor:(UIColor *)startColor
                   endColor:(UIColor*)endColor
                    context:(CGContextRef)ctx
{
  CGContextSaveGState(ctx);
  CGContextSetLineWidth(ctx, width);
  CGLineCap lineCap = self.roundedCorners ? kCGLineCapRound : kCGLineCapButt;
  CGContextSetLineCap(ctx, lineCap);
  
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path addArcWithCenter:center radius:radius - width * 0.5f startAngle:startAngle endAngle:endAngle clockwise:YES];
  CGContextAddPath(ctx, path.CGPath);
  CGContextReplacePathWithStrokedPath(ctx);
  CGContextClip(ctx);
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGFloat locations[] = { 0.0, 1.0 };
  NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
  
  CGPoint startPoint = CGPointMake(center.x-sinf(startAngle-M_PI_2)*radius, center.y+cosf(startAngle-M_PI_2)*radius);
  CGPoint endPoint = CGPointMake(center.x-sinf(endAngle-M_PI_2)*radius, center.y+cosf(endAngle-M_PI_2)*radius);
  CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint,
                              kCGGradientDrawsAfterEndLocation|kCGGradientDrawsBeforeStartLocation);
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
  
  CGContextRestoreGState(ctx);
}

@end
