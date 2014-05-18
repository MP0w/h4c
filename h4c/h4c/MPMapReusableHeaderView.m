//
//  MPMapReusableHeaderView.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPMapReusableHeaderView.h"
#import "UIView+Frame.h"

@implementation MPMapReusableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.map=[[MKMapView alloc] initWithFrame:self.bounds];
        self.map.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.map.showsUserLocation=YES;
        [self addSubview:self.map];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
