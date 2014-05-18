//
//  MPNavigationController.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPNavigationController.h"

@interface MPNavigationController ()

@end

@implementation MPNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setTintColor:[UIColor whiteColor]];

    [self.navigationBar setBarTintColor:[UIColor colorWithRed:38.0/255.0 green:45.0/255.0 blue:55.0/255.0 alpha:1]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
