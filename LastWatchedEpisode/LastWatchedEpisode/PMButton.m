//
//  PMButton.m
//  LastWatchedEpisode
//
//  Created by VM on 2/8/16.
//  Copyright © 2016 PeterMilchev. All rights reserved.
//

#import "PMButton.h"

@implementation PMButton

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        _hue = 0.5;
        _saturation = 0.5;
        _brightness = 0.5;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:150.0/256.0 green:150.0/256.0 blue:150.0/256.0 alpha:1.0] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * color = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:0.7];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, self.bounds);
}

-(void) setHue:(CGFloat)hue
{
    _hue = hue;
    [self setNeedsDisplay];
}

-(void) setSaturation:(CGFloat)saturation
{
    _saturation = saturation;
    [self setNeedsDisplay];
}

-(void) setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self setNeedsDisplay];
}
@end
