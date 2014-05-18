//
//  MPMapAnnotation.h
//  SicurStrada
//
//  Created by iCracker on 11/04/13.
//  Copyright (c) 2013 MPow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface MPMapAnnotation : NSObject<MKAnnotation>{
	CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}
-(void) setTitle:(NSString *)titletoset;
-(void) setSubtitle:(NSString *)titletoset;
-(void) setCoorWithLong:(float)lng andLat:(float)lat;

@property (nonatomic,assign) NSInteger tag;

@end
