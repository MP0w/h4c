//
//  MPOverviewViewController.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFoursquareVenue.h"
#import "MPViewController.h"
#import "UIImage+ImageEffects.h"
#import "MPGraphView.h"


@interface MPOverviewViewController : MPViewController<UIScrollViewDelegate>{
    
    BOOL up;
    
    NSMutableDictionary *corseData;
    
    CGFloat avgGCorse,avgDCorse;
    
    NSMutableDictionary *placedata;
    
    CGFloat avgGPlace, avgDPlace, minGPlace,maxGPlace,minDPlace,maxDPlace;
    
    UIScrollView *scrollview;
    
    UIImageView* imageView,*blurView;
    
    UILabel *desc,*priceStationDesc,*averageCorseDesc,*priceGasoline,*priceDiesel,*priceGasolineC,*priceDieselC;

    MPGraphView *graph,*graph2;
    
    UIButton *gasStatsButton,*dieselStatsButton;
}

@property (nonatomic,readwrite) MPFoursquareVenue *venue;

@end
