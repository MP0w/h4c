//
//  MPNumberPicker.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNumberView.h"

@interface MPNumberPicker : UIView{
    NSMutableArray *columnsViews;
}

- (id)initWithNumberOfColumns:(NSInteger)columns defaultValues:(NSArray *)def frame:(CGRect)frame maxValues:(NSArray *)max minValues:(NSArray *)minValues;

@property (nonatomic,readonly) NSInteger value;

@end
