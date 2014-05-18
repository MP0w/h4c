//
//  MPFoursquareVenue.h
//  AugmentedRealityNavigator
//
//  Created by Alex Manzella on 23/03/14.
//  Copyright (c) 2014 MPow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MPFoursquareVenue : NSObject

@property (nonatomic,readwrite) NSArray *photoUrls,*categories;
@property (nonatomic,readwrite) NSString *name,*foursquareURL,*url,*description,*address,*city,*placeId;
@property (nonatomic,readwrite) NSDictionary *contacts;
@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,assign) CGFloat rating,distance;
@property (nonatomic,assign) NSInteger hereNow;
@property (nonatomic,assign) CGFloat priceG,priceD;

- (instancetype) initWithDictionary:(NSDictionary *)venueObject;

@end
