

#import <UIKit/UIKit.h>

@interface UILabel (DrawAnimation)
- (void)drawOutlineAnimatedWithLineWidth:(float)lineWidth withDuration:(float)aniDuration fadeToLabel:(BOOL)fade;

- (void)drawOutlineAnimatedWithLineWidth:(float)lineWidth withDuration:(float)aniDuration withDelay:(float)delay fadeToLabel:(BOOL)fade;
@end
