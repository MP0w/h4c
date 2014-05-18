//
//  MPPointDescView.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFoursquareVenue.h"
#import <MapKit/MapKit.h>

@interface MPPointDescView : UIView{
    
    UILabel *title;
    UILabel *price1,*value1;
    UILabel *price2,*value2;
    
}

@property (nonatomic,copy) NSString* placeId;
@property (nonatomic,assign) MPFoursquareVenue* venue;

-(id)initWithVenue:(MPFoursquareVenue *)venue frame:(CGRect)frame;

-(void)showInfo;

@end
