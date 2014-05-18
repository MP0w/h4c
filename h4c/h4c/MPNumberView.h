//
//  MPNumberView.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPSubNumberView.h"

@interface MPNumberView : UIView{
    
    NSMutableDictionary *numbersView;
    
    NSInteger min,max,def;
    
    MPSubNumberView* current;
    
    MPSubNumberView *currentselected;
    
    NSInteger stopIndex;
}

- (id)initWithFrame:(CGRect)frame min:(NSInteger)min max:(NSInteger)max defaultValue:(NSInteger)defaultValue;

- (NSInteger)value;

@end
