//
//  MPSubmitViewController.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFoursquareVenue.h"
#import "MPViewController.h"
#import "MPOpenDataWrapper+externalServer.h"

#import "MPNumberPicker.h"

@interface MPSubmitViewController : MPViewController{
    
    MPNumberPicker *numberPicker;
    
    UILabel *desc;
    
    UIButton *updateButton;
    
    MPNumberPicker *pickerG;
    MPNumberPicker *pickerD;

}

@property (nonatomic,readwrite) MPFoursquareVenue *venue;


@end
