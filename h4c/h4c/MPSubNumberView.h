//
//  MPSubNumberView.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPSubNumberView : UIView{
    
    UILabel *label;
}

@property (nonatomic,assign) NSInteger value;

- (id)initWithFrame:(CGRect)frame value:(NSInteger)value;

@end
