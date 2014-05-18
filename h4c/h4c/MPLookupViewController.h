//
//  MPLookupViewController.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MPMapReusableHeaderView.h"
#import "MPLookupCollectionViewLayout.h"
#import "MPFourSquareWrapper.h"
#import "MPLookupCollectionViewCell.h"
#import "MPFoursquareVenue.h"
#import "MPMapAnnotation.h"
#import "PlaceOfInterest.h"
#import "MPPointDescView.h"
#import "MPOverviewViewController.h"

@interface MPLookupViewController : MPViewController<CLLocationManagerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,MKMapViewDelegate,MKMapViewDelegate>{
    
    CLLocationManager *locationManager;
    MKMapView *map;
    
    MPMapReusableHeaderView *mapView;
    
    UICollectionView *_collectionView;
    
    NSMutableArray *places;
    
    BOOL mapExpanded;
    
    UIBarButtonItem *augmentedRealityButton;
}

@end
