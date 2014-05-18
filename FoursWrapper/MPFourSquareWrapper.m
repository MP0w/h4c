#import "MPFourSquareWrapper.h"

@implementation MPFourSquareWrapper

+ (void) requestForType:(NSString *)type method:(NSString *)method params:(NSDictionary *)params complentionHandler:(void (^)(NSDictionary *))complentionHandler{
    
    NSString *url=[NSString stringWithFormat:@"https://api.foursquare.com/v2/%@/%@?oauth_token=FJAW0UIVK5Y04MB0QJZTWQAQDK4HYJEXS3RQIGNYJMQ5SWVW&v=20130420",type,method];
    
    NSInteger cursor=0;
    for (NSString* value in params.allValues) {
        url=[url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",[params.allKeys objectAtIndex:cursor],value]];
        cursor++;
    }
    NSURLRequest *requests = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    [NSURLConnection sendAsynchronousRequest:requests queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error==nil && data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            
            complentionHandler(resp);
        }
    }];
}



+ (void) requestPOIFor:(CLLocationCoordinate2D)coordinate complentionHandler:(void (^)(NSDictionary *))complentionHandler{
    [MPFourSquareWrapper requestForType:@"venues" method:@"search" params:@{@"ll":[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude]} complentionHandler:complentionHandler];
}

+ (void) requestPlaceDetailForPlaceID:(NSString *)placeID complentionHandler:(void (^)(NSDictionary *, MPFoursquareVenue *))complentionHandler{
    
    [MPFourSquareWrapper requestForType:@"venues" method:placeID params:nil complentionHandler:^(NSDictionary *response) {
        complentionHandler(response,[[MPFoursquareVenue alloc] initWithDictionary:[[response objectForKey:@"response"] objectForKey:@"venue"]]);
    }];
}

+ (void) requestPlacePhotoForPlaceID:(NSString *)placeID complentionHandler:(void (^)(NSDictionary *, NSArray *))complentionHandler{
    
    [MPFourSquareWrapper requestForType:[@"venues/" stringByAppendingString:placeID] method:@"photos" params:nil complentionHandler:^(NSDictionary *response) {
        
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        
        NSInteger cursor=0;
        for (NSDictionary* photoObj in [[[response objectForKey:@"response"] objectForKey:@"photos"] objectForKey:@"items"]) {
            NSString *urlStr=[NSString stringWithFormat:@"%@original%@",[photoObj objectForKey:@"prefix"],[photoObj objectForKey:@"suffix"]];
            [arr addObject:urlStr];
            cursor++;
        }
        
        complentionHandler(response,arr.count ? arr : nil);
    }];
}



#pragma  mark - GasStation

+ (void) requestGasStationsNearPoint:(CLLocationCoordinate2D)point complentionHandler:(void(^)(NSArray *venues))complentionHandler{
    
    [MPFourSquareWrapper requestForType:@"venues" method:@"search" params:@{@"ll":[NSString stringWithFormat:@"%f,%f",point.latitude,point.longitude],@"categoryId": @"4bf58dd8d48988d113951735"} complentionHandler:^(NSDictionary *response) {
        
        NSMutableArray *venues=[[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in [[response objectForKey:@"response"] objectForKey:@"venues"]) {
            [venues addObject:[[MPFoursquareVenue alloc] initWithDictionary:dict]];
        }
        
        complentionHandler(venues);
    }];

}


@end
