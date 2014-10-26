//
//  GradientView.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-10-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    if (self)
    {
        [self customInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self customInitialization];
    }
    return self;
}

- (void)customInitialization
{
    _gradientLayer = [CAGradientLayer layer];
    self.backgroundColor = [UIColor clearColor];
    [self.layer insertSublayer:_gradientLayer atIndex:0];
    _gradientLayer.frame = self.bounds;
}

- (void)setGradientColors:(NSArray *)gradientColors
{
    self.gradientLayer.colors = gradientColors;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

@end
