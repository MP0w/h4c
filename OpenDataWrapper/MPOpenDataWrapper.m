//
//  MPOpenDataWrapper.m
//  h4c
//
//  Created by Alex Manzella on 16/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPOpenDataWrapper.h"

@implementation MPOpenDataWrapper

+ (void) requestForPortal:(NSString *)portalUrl method:(NSString *)method params:(NSDictionary *)params complentionHandler:(void (^)(id))complentionHandler{
    
    NSString *url=[NSString stringWithFormat:@"%@%@?",portalUrl,method];
    
    NSInteger cursor=0;
    for (NSString* value in params.allValues) {
        url=[url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",[params.allKeys objectAtIndex:cursor],value]];
        cursor++;
    }
    NSURLRequest *requests = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:requests queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error==nil && data) {
            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            
            complentionHandler(resp);
        }
    }];
}

#pragma mark - Corsica

+ (void) getCorsicansAvailableDatasetsWithComplentionHandler:(void (^)(NSDictionary *))complentionHandler{
    [MPOpenDataWrapper requestForPortal:@"http://data.corse.fr/api/datasets/1.0/" method:@"search/" params:@{@"rows":@"1000"} complentionHandler:complentionHandler];
}



+ (void) requestFromCorsicanPortalDataset:(NSString *)dataset params:(NSDictionary *)params complentionHandler:(void (^)(NSDictionary *))complentionHandler{
    
    NSMutableDictionary *allparams=[[NSMutableDictionary alloc] initWithDictionary:params];
    
    [allparams setObject:dataset forKey:@"dataset"];
    
    [MPOpenDataWrapper requestForPortal:CorseOpenDataBaseUrl method:@"search" params:allparams complentionHandler:complentionHandler];
}



#pragma mark - GasStation

+ (void) requestFromCorsicanPortalGasStationsStatsWithCount:(NSInteger)count cursor:(NSInteger)cursor orderBy:(NSString *)orderBy otherParams:(NSDictionary *)params complentionHandler:(void (^)(NSDictionary *))complentionHandler{
    
    if (!orderBy) {
        orderBy=@"date";
    }
    
    if (!count) {
        count=30;
    }
    
    [MPOpenDataWrapper requestFromCorsicanPortalDataset:prixcarburant params:@{@"rows":[NSString stringWithFormat:@"%li",(long)count],@"start":[NSString stringWithFormat:@"%li",(long)cursor],@"sort":orderBy} complentionHandler:complentionHandler];
    
}


+ (void) requestFromCorsicanPortalGasStationsStatsWithComplentionHandler:(void (^)(NSDictionary *))complentionHandler{
    [MPOpenDataWrapper requestFromCorsicanPortalGasStationsStatsWithCount:0 cursor:0 orderBy:nil otherParams:nil complentionHandler:complentionHandler];
}


@end
