//
//  MPOpenDataWrapper.h
//  h4c
//
//  Created by Alex Manzella on 16/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCorsicanDataSets.h"
#import "MPHomerDataSetsProviders.h"



@interface MPOpenDataWrapper : NSObject

+ (void) requestForPortal:(NSString *)portalUrl method:(NSString *)method params:(NSDictionary *)params complentionHandler:(void (^)(id dict))complentionHandler;


#pragma mark - Corsica

+ (void) getCorsicansAvailableDatasetsWithComplentionHandler:(void (^)(NSDictionary *))complentionHandler;


+ (void) requestFromCorsicanPortalDataset:(NSString *)dataset params:(NSDictionary *)params complentionHandler:(void (^)(NSDictionary *dict))complentionHandler;


#pragma mark - GasStation

+ (void) requestFromCorsicanPortalGasStationsStatsWithCount:(NSInteger)count cursor:(NSInteger)cursor orderBy:(NSString *)orderBy otherParams:(NSDictionary *)params complentionHandler:(void (^)(NSDictionary *dict))complentionHandler;

+ (void) requestFromCorsicanPortalGasStationsStatsWithComplentionHandler:(void (^)(NSDictionary *dict))complentionHandler;


@end
