#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MPFoursquareVenue.h"

@interface MPFourSquareWrapper : NSObject

+ (void) requestForType:(NSString *)type method:(NSString *)method params:(NSDictionary *)params complentionHandler:(void(^)(NSDictionary *response))complentionHandler;


+ (void) requestPOIFor:(CLLocationCoordinate2D)coordinate complentionHandler:(void(^)(NSDictionary *response))complentionHandler;


+ (void) requestPlaceDetailForPlaceID:(NSString *)placeID complentionHandler:(void(^)(NSDictionary *response,MPFoursquareVenue *venue))complentionHandler;


+ (void) requestPlacePhotoForPlaceID:(NSString *)placeID complentionHandler:(void(^)(NSDictionary *response,NSArray *photoUrls))complentionHandler;



#pragma  mark - GasStation

+ (void) requestGasStationsNearPoint:(CLLocationCoordinate2D)point complentionHandler:(void(^)(NSArray *venues))complentionHandler;



@end

