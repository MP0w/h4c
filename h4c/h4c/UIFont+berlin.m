//
//  UIFont+berlin.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "UIFont+berlin.h"

@implementation UIFont (berlin)


+ (UIFont *)berlinItalicFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Berlin-Italic" size:size];
}

+ (UIFont *)berlinFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Berlin" size:size];
}

+ (UIFont *)berlinBoldFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Berlin Bold" size:size];
}

+ (UIFont *)berlinXBoldFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"Berlin X-Bold" size:size];
}


@end
