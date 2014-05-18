//
//  MPLookupViewController.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPLookupViewController.h"
#import "MPARViewController.h"

#define MAPHEIGHT 200
#define SPAN 0.2

static NSString *headerID=@"headerID";
static NSString *cellID=@"cellID";

@interface MPLookupViewController ()

@end

@implementation MPLookupViewController


- (NSString *)title{
    return NSLocalizedString(@"Lookup", nil);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    [locationManager startUpdatingLocation];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[MPLookupCollectionViewLayout alloc] init]];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor clearColor];
    [_collectionView registerClass:[MPMapReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    [_collectionView registerClass:[MPLookupCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:_collectionView];
    
    
    mapView=[[MPMapReusableHeaderView alloc] initWithFrame:self.view.bounds];
    mapView.clipsToBounds=NO;
    map=mapView.map;
    map.delegate=self;
    map.superview.clipsToBounds=NO;
    [_collectionView addSubview:mapView];
    
    augmentedRealityButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ar"] style:UIBarButtonItemStylePlain target:self action:@selector(goToAR:)];
    [self.navigationItem setRightBarButtonItem:augmentedRealityButton];
    
    UIImage *image = [UIImage imageNamed:@"logo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];

    
}

-(void)goToAR:(id)sender{
    
    NSMutableArray *poiArray=[[NSMutableArray alloc] init];
    
    for (MPFoursquareVenue* venue in places) {
        
        MPPointDescView* view=[[MPPointDescView alloc] initWithVenue:venue frame:CGRectMake(0, 0, 150, 40)];
        PlaceOfInterest *poi=[PlaceOfInterest placeOfInterestWithView:view at:[[CLLocation alloc] initWithLatitude:venue.location.latitude longitude:venue.location.longitude]];
        [poiArray addObject:poi];
        
    }
    
    MPARViewController *arVC=[[MPARViewController alloc] init];
    
    [arVC setPois:poiArray];
    
    [self.navigationController pushViewController:arVC animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (!map) {
        return;
    }
    
    map.centerCoordinate=locationManager.location.coordinate;
    map.region=MKCoordinateRegionMake(locationManager.location.coordinate, MKCoordinateSpanMake(SPAN, SPAN));
    [locationManager stopUpdatingLocation];
    
    [MPFourSquareWrapper requestGasStationsNearPoint:manager.location.coordinate complentionHandler:^(NSArray *venues) {
        
        for (MPFoursquareVenue *venue in venues) {
            venue.distance=[[[CLLocation alloc] initWithLatitude:venue.location.latitude longitude:venue.location.longitude] distanceFromLocation:locationManager.location]/1000;
        }
        
        NSSortDescriptor * sortDesc = [[NSSortDescriptor alloc] initWithKey:@"self.distance" ascending:YES];
        
        places=[[NSMutableArray alloc]initWithArray:venues];
        
        [places sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
        
        
        
        if(venues.count){
            
            CGPoint center=[map convertCoordinate:locationManager.location.coordinate toPointToView:map];
            center.y+=(self.view.height - MAPHEIGHT)/2;
            
            [map setCenterCoordinate:[map convertPoint:center toCoordinateFromView:map] animated:YES];
            map.scrollEnabled=NO;
            [_collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:.15];
            
            [self performSelector:@selector(addMapAnnotations) withObject:nil afterDelay:.2];
            
        }
    }];


}



- (void)addMapAnnotations{
    
    [map removeAnnotations:map.annotations];
    
    NSInteger cursor=0;
    
    for (MPFoursquareVenue *venue in places) {
        MPMapAnnotation* ann=[[MPMapAnnotation alloc] init];
        [ann setCoorWithLong:venue.location.longitude andLat:venue.location.latitude];
        [ann setTitle:venue.name];
        [ann setSubtitle:venue.address];
        ann.tag=cursor++;
        
        [map addAnnotation:ann];
    }
    

}


- (void)expandMap{
    mapExpanded=YES;
    map.scrollEnabled=YES;
    
    [UIView animateWithDuration:.15 animations:^{
        [_collectionView setContentInset:UIEdgeInsetsMake(_collectionView.height-MAPHEIGHT-90, 0, 0, 0)];
    }];
    
}

- (void)collapseMap{
    
    mapExpanded=NO;
    map.scrollEnabled=NO;

    [_collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    CGPoint center=[map convertCoordinate:locationManager.location.coordinate toPointToView:map];
    center.y+=(self.view.height - MAPHEIGHT)/2;
    
    [map setCenterCoordinate:[map convertPoint:center toCoordinateFromView:map] animated:YES];

}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return places.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MPLookupCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    MPFoursquareVenue *venue=[places objectAtIndex:indexPath.item];
    
    cell.title.text=venue.name;
    cell.address.text=[NSString stringWithFormat:@"%@%@%@",venue.address ? venue.address : @"",(venue.address ? @", " : @""),venue.city ? venue.city : @""];
    cell.distance.text=[NSString stringWithFormat:@"%.2f km",venue.distance];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[CACHEDIR stringByAppendingPathComponent:venue.placeId]]) {
        cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:[CACHEDIR stringByAppendingPathComponent:venue.placeId]]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    MPOverviewViewController *overview=[[MPOverviewViewController alloc] init];
    overview.venue=[places objectAtIndex:indexPath.item];
    [self.navigationController pushViewController:overview animated:YES];

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.width, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.width, places.count ?  MAPHEIGHT : collectionView.height);
}


#pragma mark -map delegate


- (MKAnnotationView *)mapView:(MKMapView *)mapview_ viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    
    MKAnnotationView *annotationView = [mapview_ dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if(annotationView)
        return annotationView;
    else
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:AnnotationIdentifier];
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"marker"];
        return annotationView;
    }
    return nil;
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if (view.annotation==map.userLocation) {
        return;
    }
    
    view.canShowCallout=NO;

    MPPointDescView *annotationView=[[MPPointDescView alloc] initWithVenue:(MPFoursquareVenue *)[places objectAtIndex:[(MPMapAnnotation *)view.annotation tag]] frame:CGRectMake(-50, -80, 150, 40)];
    //[annotationView setVenue:[places objectAtIndex:[(MPMapAnnotation *)view.annotation tag]]];
    [annotationView showInfo];
    annotationView.tag=38;
    [view addSubview:annotationView];
    
    [UIView animateWithDuration:.2 animations:^{
        annotationView.height=160;
    }];
    
    MKCoordinateSpan span;
    span = MKCoordinateSpanMake(0.004, 0.004);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(view.annotation.coordinate, span);
    CGRect frame=[map convertRegion:region toRectToView:map];
    frame.origin.y+=3;
    [map setRegion:[map convertRect:frame toRegionFromView:map] animated:YES];
    
    [self expandMap];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:0 animated:YES];
}




//- (void)tappedPlace:(UIButton *)sender{
//    NSInteger index=sender.tag;
//    
//}

- (void)mapView:(MKMapView *)aMapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [UIView animateWithDuration:.1 animations:^{
        [[view viewWithTag:38] setAlpha:0];
    }completion:^(BOOL finished) {
        [[view viewWithTag:38] removeFromSuperview];

    }];

    MKCoordinateRegion region = MKCoordinateRegionMake(map.userLocation.coordinate, MKCoordinateSpanMake(SPAN, SPAN));
    [map setRegion:region animated:YES];
    
}




#pragma mark Scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==_collectionView && places.count) {
        
    
        CGFloat offset=scrollView.contentOffset.y;
        
        if(offset<0){
            mapView.y=offset;
            mapView.height=_collectionView.height-offset;
        }else{
            mapView.y=offset;
        }
        
        if(offset<-150)
            [self expandMap];
        
        if (mapExpanded && offset>50) {
            [self collapseMap];
        }
            
    }
}


@end
