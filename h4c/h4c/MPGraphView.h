//
//  MPGraphView.h
//  h4c
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPGraphView : UIView{
    
    NSMutableArray *buttons;
    
    UILabel *label;
}


@property (nonatomic,readwrite) NSArray *avgvalues,*values;

@end
