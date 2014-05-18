//
//  MPOpenDataWrapper+externalServer.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPOpenDataWrapper+externalServer.h"

#define stringify(x) [NSString stringWithFormat:@"%f",x]

@implementation MPOpenDataWrapper (externalServer)


+ (void) requestPlacesInfoNearPoint:(CLLocationCoordinate2D)point distance:(CGFloat)distance complentionHandler:(void (^)(id dict))complentionHandler{
    
    [MPOpenDataWrapper requestForPortal:mpowPortal method:@"getspot.php" params:@{@"lat":stringify(point.latitude),@"long":stringify(point.longitude),@"distance":stringify((distance ? distance : 10))} complentionHandler:complentionHandler];
}


+ (NSDictionary *)dictionaryForGasolinePrice:(CGFloat)price diesel:(CGFloat)diesel{
    return @{@"priceB": stringify(price),@"priceG": stringify(diesel)};
}

+ (void) requestPlacesInfoForPlaceID:(NSString *)placeId complentionHandler:(void (^)(id array))complentionHandler{

    [MPOpenDataWrapper requestForPortal:mpowPortal method:@"getspotofplace.php" params:@{@"placeId":placeId} complentionHandler:complentionHandler];

}


+ (void) sendPlaceInfoForPoint:(CLLocationCoordinate2D)point message:(NSString *)message placeId:(NSString *)placeId productsPrices:(NSDictionary *)productsPrices complentionHandler:(void (^)(BOOL success, id dict))complentionHandler{
    
    NSMutableDictionary *query=[[NSMutableDictionary alloc] initWithObjects:@[stringify(point.latitude),stringify(point.longitude),placeId] forKeys:@[@"lat",@"long",@"stationId"]];
    
//    if (message) {
//        [query setObject:message forKey:@"text"];
//    }
    
    for (NSString *key in productsPrices.allKeys) {
        
        [query setObject:[productsPrices objectForKey:key] forKey:key];
    }
    
    [MPOpenDataWrapper requestForPortal:mpowPortal method:@"spot.php" params:query complentionHandler:^(id dict) {
        
        BOOL success=[[dict objectForKey:@"result"] isEqualToString:@"ok"];
        
        complentionHandler(success,dict);
    
    }];
    
}

@end
