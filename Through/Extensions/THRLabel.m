//
//  THRLabel.m
//  Through
//
//  Created by Renzo Crisóstomo on 02/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRLabel.h"

@implementation THRLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {20, 10, 0, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
