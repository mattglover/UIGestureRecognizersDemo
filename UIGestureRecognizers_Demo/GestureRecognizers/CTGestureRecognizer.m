//
//  CTGestureRecognizer.m
//  UIGestureRecognizers_Demo
//
//  Created by Craig Tweedy on 09/04/2013.
//  Copyright (c) 2013 Duchy Software Ltd. All rights reserved.
//

#import "CTGestureRecognizer.h"
#import "CMUnistrokeGestureRecognizer.h"
#import "GestureRecognizers.h"

@implementation CTGestureRecognizer

#define kStrokeCTPointsCount 51
CGPoint strokeCTPoints[kStrokeCTPointsCount] = {
    {412.0f, 241.0f}, {411.0f, 242.0f}, {410.0f, 242.0f}, {402.0f, 248.0f}, {392.0f, 255.0f}, {377.0f, 267.0f},
    {356.0f, 290.0f}, {343.0f, 309.0f}, {328.0f, 329.0f}, {320.0f, 347.0f}, {316.0f, 361.0f}, {310.0f, 386.0f},
    {310.0f, 404.0f}, {313.0f, 430.0f}, {330.0f, 448.0f}, {354.0f, 460.0f}, {385.0f, 469.0f}, {431.0f, 473.0f},
    {471.0f, 473.0f}, {514.0f, 460.0f}, {557.0f, 432.0f}, {595.0f, 402.0f}, {611.0f, 381.0f}, {627.0f, 354.0f},
    {638.0f, 334.0f}, {642.0f, 312.0f}, {642.0f, 286.0f}, {629.0f, 268.0f}, {607.0f, 247.0f}, {585.0f, 232.0f},
    {569.0f, 225.0f}, {546.0f, 218.0f}, {530.0f, 218.0f}, {521.0f, 218.0f}, {509.0f, 218.0f}, {504.0f, 218.0f},
    {507.0f, 218.0f}, {527.0f, 219.0f}, {564.0f, 225.0f}, {622.0f, 232.0f}, {685.0f, 241.0f}, {725.0f, 245.0f},
    {764.0f, 250.0f}, {786.0f, 250.0f}, {804.0f, 250.0f}, {814.0f, 250.0f}, {816.0f, 250.0f}, {819.0f, 250.0f},
    {821.0f, 250.0f}, {822.0f, 250.0f}, {821.0f, 249.0f}
};

-(id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        UIBezierPath *ctBezierPath = [UIBezierPath bezierPath];
        
        [ctBezierPath moveToPoint:strokeCTPoints[0]];
        
        for (NSUInteger j=1; j<kStrokeCTPointsCount; j++) {
            [ctBezierPath addLineToPoint:strokeCTPoints[j]];
        }
        
        [self registerUnistrokeWithName:@"CTGesture" bezierPath:ctBezierPath];
    }
    return self;
}

@end
