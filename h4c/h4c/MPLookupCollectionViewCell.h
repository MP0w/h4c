//
//  MPLookupCollectionViewCell.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPLookupCollectionViewCell : UICollectionViewCell


@property (nonatomic,readwrite) UIImageView *imageView;
@property (nonatomic,readwrite) UILabel *title,*address,*distance;

@end
