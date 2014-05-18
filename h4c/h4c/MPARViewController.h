//
//  MPARViewController.h
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPViewController.h"
#import "ARView.h"

@interface MPARViewController : MPViewController{
    ARView *arview;
}


@property (nonatomic,readwrite) NSMutableArray *pois;

@end
