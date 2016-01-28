//
//  CALayer+DrawAnimation.m
//  Snappr
//
//  Created by Sebastian Cain on 6/4/15.
//  Copyright (c) 2015 Joshua Liu. All rights reserved.
//

#import "CALayer+DrawAnimation.h"

@implementation CALayer (DrawAnimation)

-(void)animateStrokeWithDuration:(float)duration {
	
	CGColorRef oriColor = self.borderColor;
	
	[self setBorderColor:[[UIColor clearColor]CGColor]];
	
	CABasicAnimation *drawStrokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	drawStrokeAnimation.fromValue = @0;
	drawStrokeAnimation.toValue = @1;
	drawStrokeAnimation.duration = duration;
	//drawStrokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
	
	CAShapeLayer *newLayer = [CAShapeLayer layer];
	newLayer.frame = self.bounds;
	newLayer.path = (__bridge CGPathRef)(path);
	newLayer.strokeColor = oriColor;
	newLayer.lineWidth = self.borderWidth;
	[self addSublayer:newLayer];
	
	
	[CATransaction begin]; {
		[CATransaction setCompletionBlock:^{
			[self setBorderColor:oriColor];
			[newLayer removeFromSuperlayer];
		}];
		//Animate Path
		[newLayer addAnimation:drawStrokeAnimation forKey:@"draw"];
	} [CATransaction commit];
		
}

@end
