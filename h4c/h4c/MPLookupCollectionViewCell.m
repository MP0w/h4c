//
//  MPLookupCollectionViewCell.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPLookupCollectionViewCell.h"
#import "UIView+Frame.h"

@implementation MPLookupCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat padding=7;
        
        self.backgroundColor=[UIColor colorWithRed:38.0/255.0 green:45.0/255.0 blue:55.0/255.0 alpha:.85];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 12, 80, 55)];
        self.imageView.image=[UIImage imageNamed:@"no_picture"];
        self.imageView.contentMode=UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds=YES;
        [self addSubview:self.imageView];
        
        CGFloat x=self.imageView.width+self.imageView.x+padding;
        CGFloat w=self.width-x-padding;
        
        self.title=[[UILabel alloc] initWithFrame:CGRectMake(x, self.imageView.y-2, w, 20)];
        self.title.textColor=[UIColor colorWithRed:253.0/255.0 green:83.0/255.0 blue:23.0/255.0 alpha:1];
        self.title.font=[UIFont berlinBoldFontWithSize:17];
        [self addSubview:self.title];
        
        
        self.address=[[UILabel alloc] initWithFrame:CGRectMake(x, self.title.y+self.title.height, w, 20)];
        self.address.textColor=[UIColor whiteColor];
        self.address.font=[UIFont berlinItalicFontWithSize:15];
        [self addSubview:self.address];
        
        
        self.distance=[[UILabel alloc] initWithFrame:CGRectMake(x, self.address.y+self.address.height, w, 20)];
        self.distance.textColor=[UIColor colorWithRed:0.976 green:0.754 blue:0.184 alpha:1.000];
        self.distance.font=[UIFont berlinFontWithSize:15];
        [self addSubview:self.distance];
        
    }
    return self;
}

- (void)prepareForReuse{
    
    [super prepareForReuse];
    self.imageView.image=[UIImage imageNamed:@"no_picture"];

}


@end
