//
//  DropDownArrowView.m
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Source code adapted from RogChap http://rogchap.com/2013/08/13/simple-ios-dropdown-control-using-uitextfield/
//

#import "DropDownArrowView.h"

@implementation DropDownArrowView

+(DropDownArrowView*) default {
    DropDownArrowView* view = [[DropDownArrowView alloc] initWithFrame:CGRectMake(0, 0, 31, 28)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 0.827 green: 0.827 blue: 0.827 alpha: 1];
    //// Frames
    CGRect frame = self.bounds;
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 24.82, CGRectGetMinY(frame) + 8.08)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 25.98, CGRectGetMinY(frame) + 9.25)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 17.01, CGRectGetMinY(frame) + 18.22)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 17.01, CGRectGetMinY(frame) + 18.22)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 15.85, CGRectGetMinY(frame) + 19.38)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 15.85, CGRectGetMinY(frame) + 19.38)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 15.85, CGRectGetMinY(frame) + 19.38)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 14.68, CGRectGetMinY(frame) + 18.22)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 14.68, CGRectGetMinY(frame) + 18.22)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5.71, CGRectGetMinY(frame) + 9.25)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 6.88, CGRectGetMinY(frame) + 8.08)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 15.85, CGRectGetMinY(frame) + 17.05)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 24.82, CGRectGetMinY(frame) + 8.08)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    bezierPath.usesEvenOddFillRule = YES;
    [strokeColor setFill];
    [bezierPath fill];
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 28)];
    [bezier2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame))];
    [strokeColor setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 31, CGRectGetMinY(frame) + 28)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 31, CGRectGetMinY(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 31, CGRectGetMinY(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 31, CGRectGetMinY(frame))];
    [strokeColor setStroke];
    bezier3Path.lineWidth = 1;
    [bezier3Path stroke];
}

@end
