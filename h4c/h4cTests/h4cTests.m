//
//  h4cTests.m
//  h4cTests
//
//  Created by Alex Manzella on 16/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPOpenDataWrapper.h"

@interface h4cTests : XCTestCase

@end

@implementation h4cTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetCorsicanDatasets
{

    [MPOpenDataWrapper getCorsicansAvailableDatasetsWithComplentionHandler:^(NSDictionary *dict) {
        NSString* dec=@"";
        for (NSDictionary* set in [dict objectForKey:@"datasets"]) {
            dec=[dec stringByAppendingFormat:@"static NSString *k%@=@\"%@\";\n",[[set objectForKey:@"datasetid"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"],[set objectForKey:@"datasetid"]];
        }
        NSLog(@"%@",dec);
        
        
    }];

}

@end
