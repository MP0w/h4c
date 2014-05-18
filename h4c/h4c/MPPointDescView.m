//
//  MPPointDescView.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPPointDescView.h"
#import "MPOpenDataWrapper+externalServer.h"

@implementation MPPointDescView


-(id)initWithVenue:(MPFoursquareVenue *)venue frame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        

        self.backgroundColor=[UIColor colorWithRed:38.0/255.0 green:45.0/255.0 blue:55.0/255.0 alpha:1];
        self.layer.cornerRadius=5;
        self.clipsToBounds=YES;
        
        title=[[UILabel alloc] initWithFrame:CGRectMake(7, 5, self.width-14, 30)];
        title.text=[venue.name uppercaseString];
        title.textColor=[UIColor colorWithRed:253.0/255.0 green:83.0/255.0 blue:23.0/255.0 alpha:1];
        title.font=[UIFont berlinBoldFontWithSize:17];
        title.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:title];
        
        price1=[[UILabel alloc] initWithFrame:CGRectMake(5, self.height, (self.width-30)/2, 60)];
        price1.textColor=[UIColor whiteColor];
        price1.font=[UIFont berlinFontWithSize:17];
        price1.numberOfLines=2;
        price1.text=NSLocalizedString(@"Gasoline\n/L", nil);
        price1.textAlignment=NSTextAlignmentRight;
        [self addSubview:price1];
        
        price2=[[UILabel alloc] initWithFrame:CGRectMake(5, self.height+price1.height, price1.width, 60)];
        price2.textColor=[UIColor whiteColor];
        price2.font=[UIFont berlinFontWithSize:17];
        price2.numberOfLines=2;
        price2.textAlignment=NSTextAlignmentRight;
        price2.text=NSLocalizedString(@"Diesel\n/L", nil);
        [self addSubview:price2];
        
        
        value1=[[UILabel alloc] initWithFrame:CGRectMake(price1.x+price1.width+10, price1.y+12, (self.width-30)/2, 35)];
        value1.textColor=[UIColor colorWithRed:38.0/255.0 green:45.0/255.0 blue:55.0/255.0 alpha:1];
        value1.font=[UIFont berlinBoldFontWithSize:23];
        value1.backgroundColor=[UIColor colorWithRed:0.981 green:0.495 blue:0.144 alpha:1.000];
        value1.textAlignment=NSTextAlignmentCenter;
        [self addSubview:value1];
        
        value2=[[UILabel alloc] initWithFrame:CGRectMake(value1.x, price2.y+12, price1.width, value1.height)];
        value2.textColor=[UIColor colorWithRed:38.0/255.0 green:45.0/255.0 blue:55.0/255.0 alpha:1];
        value2.backgroundColor=[UIColor colorWithRed:0.981 green:0.495 blue:0.144 alpha:1.000];
        value2.font=[UIFont berlinBoldFontWithSize:23];
        value2.textAlignment=NSTextAlignmentCenter;
        [self addSubview:value2];
        
        value1.text=[[NSString stringWithFormat:@"%.3f",0.0] stringByReplacingOccurrencesOfString:@"." withString:@","];
        value2.text=[[NSString stringWithFormat:@"%.3f",0.0] stringByReplacingOccurrencesOfString:@"." withString:@","];

        
        self.placeId=venue.placeId;
    }
    return self;
}


-(void)setVenue:(MPFoursquareVenue *)venue{
    title.text=[venue.name uppercaseString];
    self.placeId=venue.placeId;
}

- (void)showInfo{
    
    [MPOpenDataWrapper requestPlacesInfoForPlaceID:self.placeId complentionHandler:^(id array) {
        NSString *priceB=[[array lastObject] objectForKey:@"priceB"];
        NSString *priceG=[[array lastObject] objectForKey:@"priceG"];
        
        value1.text=[[NSString stringWithFormat:@"%.3f",[priceB floatValue]] stringByReplacingOccurrencesOfString:@"." withString:@","];
        value2.text=[[NSString stringWithFormat:@"%.3f",[priceG floatValue]] stringByReplacingOccurrencesOfString:@"." withString:@","];

    }];
    

}


- (void)setFrame:(CGRect)frame{
    
    if (frame.size.height<=40) {
        title.textAlignment=NSTextAlignmentCenter;
    }else title.textAlignment=NSTextAlignmentLeft;

    
    [super setFrame:frame];
}

@end
