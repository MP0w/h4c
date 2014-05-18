//
//  MPOpenDataWrapper+externalServer.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPOpenDataWrapper.h"
#import <CoreLocation/CoreLocation.h>

static NSString *mpowPortal=@"http://mpow.it/h4cback/";

@interface MPOpenDataWrapper (externalServer)

+ (void) requestPlacesInfoNearPoint:(CLLocationCoordinate2D)point distance:(CGFloat)distance complentionHandler:(void (^)(id dict))complentionHandler;

+ (void) requestPlacesInfoForPlaceID:(NSString *)placeId complentionHandler:(void (^)(id dict))complentionHandler;

+ (void) sendPlaceInfoForPoint:(CLLocationCoordinate2D)point message:(NSString *)message placeId:(NSString *)placeId productsPrices:(NSDictionary *)productsPrices complentionHandler:(void (^)(BOOL success, id dict))complentionHandler;


+ (NSDictionary *)dictionaryForGasolinePrice:(CGFloat)gasoline diesel:(CGFloat)diesel;

@end
