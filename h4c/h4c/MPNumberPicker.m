//
//  MPNumberPicker.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPNumberPicker.h"

#define PADDING 3

@implementation MPNumberPicker

- (id)initWithNumberOfColumns:(NSInteger)columns defaultValues:(NSArray *)def frame:(CGRect)frame maxValues:(NSArray *)max minValues:(NSArray *)minValues
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds=NO;

        columnsViews=[[NSMutableArray alloc] init];
        CGFloat w=35;

        for (NSInteger i=0; i<columns; i++) {
            
            MPNumberView *view=[[MPNumberView alloc] initWithFrame:CGRectMake(i*(w+PADDING)+(i>0 ? 10: 0), 0, 35, 45) min:[[minValues objectAtIndex:i] integerValue] max:[[max objectAtIndex:i] integerValue] defaultValue:[[def objectAtIndex:i] integerValue]];
            [self addSubview:view];
            [columnsViews addObject:view];
        }
        
        
    }
    return self;
}

-(NSInteger)value{
    
    NSInteger pos=1;
    
    NSInteger total=0;
    
    for (MPNumberView* num in [columnsViews reverseObjectEnumerator]) {
        total+=[num value]*pos;
        pos*=10;
    }
    
    return total;
}


@end
