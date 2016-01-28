//
//  UILabel+DrawAnimation.h
//  Snappr
//
//  Created by Sebastian Cain on 6/2/15.
//  Copyright (c) 2015 Joshua Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DrawAnimation)
- (void)drawOutlineAnimatedWithLineWidth:(float)lineWidth withDuration:(float)aniDuration fadeToLabel:(BOOL)fade;

- (void)drawOutlineAnimatedWithLineWidth:(float)lineWidth withDuration:(float)aniDuration withDelay:(float)delay fadeToLabel:(BOOL)fade;
@end
