//
//  SPartyGestureRecognizer.m
//  UIGestureRecognizers_Demo
//
//  Created by Craig Tweedy on 09/04/2013.
//  Copyright (c) 2013 Duchy Software Ltd. All rights reserved.
//

#import "SPartyGestureRecognizer.h"
#import "GestureRecognizers.h"

@implementation SPartyGestureRecognizer

#define kStrokeSPartyPointsCount 41
CGPoint strokeSPartyPoints[kStrokeSPartyPointsCount] = {
    {491.0f, 215.0f}, {490.0f, 215.0f}, {488.0f, 215.0f}, {474.0f, 215.0f}, {446.0f, 215.0f}, {418.0f, 215.0f},
    {391.0f, 215.0f}, {373.0f, 218.0f}, {355.0f, 223.0f}, {346.0f, 228.0f}, {338.0f, 234.0f}, {335.0f, 238.0f},
    {334.0f, 240.0f}, {333.0f, 242.0f}, {333.0f, 246.0f}, {339.0f, 252.0f}, {351.0f, 259.0f}, {371.0f, 266.0f},
    {401.0f, 276.0f}, {430.0f, 286.0f}, {451.0f, 290.0f}, {476.0f, 297.0f}, {495.0f, 304.0f}, {510.0f, 309.0f},
    {522.0f, 317.0f}, {528.0f, 320.0f}, {533.0f, 324.0f}, {535.0f, 327.0f}, {536.0f, 330.0f}, {536.0f, 333.0f},
    {533.0f, 339.0f}, {513.0f, 350.0f}, {473.0f, 370.0f}, {432.0f, 386.0f}, {402.0f, 395.0f}, {367.0f, 405.0f},
    {342.0f, 409.0f}, {318.0f, 411.0f}, {301.0f, 412.0f}, {290.0f, 412.0f}, {290.0f, 412.0f}
};

-(id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        [bezierPath moveToPoint:strokeSPartyPoints[0]];
        
        for (NSUInteger j=1; j<kStrokeSPartyPointsCount; j++) {
            [bezierPath addLineToPoint:strokeSPartyPoints[j]];
        }
        
        [self registerUnistrokeWithName:@"SPartyGesture" bezierPath:bezierPath];
    }
    return self;
}


@end
