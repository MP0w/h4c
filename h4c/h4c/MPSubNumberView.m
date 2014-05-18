//
//  MPSubNumberView.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPSubNumberView.h"

@implementation MPSubNumberView

- (id)initWithFrame:(CGRect)frame value:(NSInteger)value
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000];

        label=[[UILabel alloc] initWithFrame:CGRectMake(0, 3, self.width, self.height)];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont berlinFontWithSize:45];
        [self addSubview:label];
        
        self.value=value;
    }
    return self;
}


-(void)setValue:(NSInteger)value{
    
    _value=value;
    
    label.text=[NSString stringWithFormat:@"%li",(long)value];
    
    
}

@end
