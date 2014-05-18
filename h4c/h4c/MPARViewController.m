//
//  MPARViewController.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPARViewController.h"
#import "PlaceOfInterest.h"

@interface MPARViewController ()

@end

@implementation MPARViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        arview=[[ARView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:arview];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [arview setPlacesOfInterest:self.pois];

    [arview start];
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [arview stop];
}



-(void)setPois:(NSMutableArray *)pois{
    
    _pois=pois;
}


- (NSString *)title{
    return NSLocalizedString(@"Around You", nil);
}

@end
