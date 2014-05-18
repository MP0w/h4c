//
//  MPLookupCollectionViewLayout.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPLookupCollectionViewLayout.h"

@implementation MPLookupCollectionViewLayout

- (id)init{
    if (self=[super init]) {
        
        
        self.minimumInteritemSpacing=.5;
        self.minimumLineSpacing=.5;
        
    }
    
    return self;
}

@end
