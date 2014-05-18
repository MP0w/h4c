//
//  MPOverviewViewController.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPOverviewViewController.h"
#import "MPSubmitViewController.h"
#import "MPFourSquareWrapper.h"

#define SQUARE_SIZE (self.view.width/3)


@interface MPOverviewViewController ()

@end

@implementation MPOverviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem* new=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"up"] style:UIBarButtonItemStylePlain target:self action:@selector(new:)];
    [self.navigationItem setRightBarButtonItem:new];
    
    scrollview=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollview.delegate=self;
    scrollview.backgroundColor=[UIColor colorWithRed:38.0/255.0 green:45.0/255.0 blue:55.0/255.0 alpha:1];
    [self.view addSubview:scrollview];
    
    scrollview.contentSize=CGSizeMake(self.view.width, self.view.height+100);
    

    desc=[[UILabel alloc] initWithFrame:CGRectMake(40, 60, self.view.width-80, 0)];
    desc.textColor=[UIColor whiteColor];
    desc.numberOfLines=0;
    desc.textAlignment=NSTextAlignmentCenter;
    [scrollview addSubview:desc];
    
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",self.venue.name ? [self.venue.name uppercaseString] : @"" , (self.venue.name && self.venue.address) ? @"\n\n":@"",self.venue.address ? self.venue.address : @""] attributes:@{NSFontAttributeName : [UIFont berlinBoldFontWithSize:20],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    if(self.venue.address)
    [attr addAttributes:@{NSFontAttributeName : [UIFont berlinItalicFontWithSize:17],NSForegroundColorAttributeName : [UIColor whiteColor]} range:[[attr string] rangeOfString:self.venue.address]];
    desc.attributedText=attr;
    
    [desc sizeToFit];
    desc.width=self.view.width-80;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[CACHEDIR stringByAppendingPathComponent:self.venue.placeId]]) {
        
        [self addImageWithData:[NSData dataWithContentsOfFile:[CACHEDIR stringByAppendingPathComponent:self.venue.placeId]]];
        
    }else{
    
        [MPFourSquareWrapper requestPlaceDetailForPlaceID:self.venue.placeId complentionHandler:^(NSDictionary *response, MPFoursquareVenue *venue) {
           
            if (venue.photoUrls.firstObject) {
                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:venue.photoUrls.firstObject]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                   
                    if(data){
                        [data writeToFile:[CACHEDIR stringByAppendingPathComponent:self.venue.placeId] atomically:YES];

                        [self addImageWithData:data];
                    }
                }];
            }
            
            
        }];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    scrollview.delegate=self;
    
    [self scrollViewDidScroll:scrollview];

    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if(up==1)
        [self setVenue:self.venue];
    else up=1;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    scrollview.delegate=nil;
    
    graph.avgvalues=nil;
    [graph removeFromSuperview]; graph=nil;

    graph2.values=nil;
    [graph2 removeFromSuperview]; graph2=nil;
    
    [super viewDidDisappear:animated];
}

- (void)addImageWithData:(NSData *)data{
    
    
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, desc.y*2+desc.height)];
    imageView.image=[UIImage imageWithData:data];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    imageView.alpha=0;
    [scrollview insertSubview:imageView belowSubview:desc];
    
    blurView=[[UIImageView alloc] initWithFrame:imageView.bounds];
    blurView.image=[[UIImage imageWithData:data] applyBlurWithRadius:10 tintColor:[UIColor colorWithWhite:0 alpha:.3] saturationDeltaFactor:1 maskImage:nil];
    blurView.contentMode=UIViewContentModeScaleAspectFill;
    blurView.clipsToBounds=YES;
    blurView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [imageView addSubview:blurView];
    
    [UIView animateWithDuration:.15 animations:^{
        imageView.alpha=1;
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    return self.venue.name;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat offset=scrollview.contentOffset.y+64;
    
    if (offset<0) {
        
        CGFloat percentage=1-(offset/-150);
        
        imageView.frame=CGRectMake(0, offset, self.view.width,60*2+desc.height-offset);
        desc.y=60+offset/2;
        desc.alpha=percentage;
        blurView.alpha=percentage;
        
    }else{
        blurView.alpha=1;
        desc.y=60;
        desc.alpha=1;
        
        if (desc.y*2+desc.height-offset>0) {
            
            imageView.frame=CGRectMake(0, offset, self.view.width,desc.y*2+desc.height-offset);
            desc.alpha=1-(offset/100);
        }
        
    }
    
    
}


- (void)setVenue:(MPFoursquareVenue *)venue{
    
    _venue=venue;
    
    [MPOpenDataWrapper requestPlacesInfoForPlaceID:venue.placeId complentionHandler:^(id array) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

            NSString *priceG=[[array lastObject] objectForKey:@"priceB"];
            NSString *priceD=[[array lastObject] objectForKey:@"priceG"];
            
            venue.priceD=[priceD floatValue];
            venue.priceG=[priceG floatValue];
            
            
            NSMutableArray *gasoline=[[NSMutableArray alloc] init];
            NSMutableArray *diesel=[[NSMutableArray alloc] init];
            NSMutableArray *dates=[[NSMutableArray alloc] init];
            
            for (NSDictionary* val in array) {
                
                [gasoline addObject:[val objectForKey:@"priceB"]];
                [diesel addObject:[val objectForKey:@"priceG"]];
                [dates addObject:[val objectForKey:@"date"]];
            }
            
            placedata=[@{@"gasoline": gasoline,@"diesel":diesel,@"dates":dates} mutableCopy];

            minDPlace=maxDPlace=venue.priceD;
            minGPlace=maxGPlace=venue.priceG;
            
            
            for (NSInteger i=0; i<gasoline.count; i++) {
                
                CGFloat d=[[diesel objectAtIndex:i] floatValue];
                CGFloat g=[[gasoline objectAtIndex:i] floatValue];
                
                if (d>maxDPlace) {
                    maxDPlace=d;
                }
                if (g>maxGPlace) {
                    maxGPlace=g;
                }
                if (d<minDPlace) {
                    minDPlace=d;
                }
                if (g<minGPlace) {
                    minGPlace=g;
                }
                avgDPlace+=d;
                avgGPlace+=g;
            }
            
            avgDPlace/=diesel.count;
            avgGPlace/=gasoline.count;
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [priceStationDesc removeFromSuperview]; priceStationDesc=nil;
                
                priceStationDesc=[self createCubeWithText:@"$\nPRICE\n(STATION)" color:[UIColor colorWithRed:255.0/255.0 green:145.0/255.0 blue:25.0/255.0 alpha:1.000] origin:CGPointMake(0, 60*2+desc.height)];
                [scrollview addSubview:priceStationDesc];
                [self animateCube:priceStationDesc];
                
                [priceGasoline removeFromSuperview]; priceGasoline=nil;

                priceGasoline=[self createCubeWithText:[self attributedStringWithTitle:NSLocalizedString(@"GASOLINE", nil) price:[[array lastObject] objectForKey:@"priceB"]] color:[UIColor colorWithRed:0.148 green:0.171 blue:0.218 alpha:1.000] origin:CGPointMake(SQUARE_SIZE, priceStationDesc.y)];
                [scrollview addSubview:priceGasoline];
                [self animateCube:priceGasoline];
                
                [priceDiesel removeFromSuperview]; priceDiesel=nil;

                priceDiesel=[self createCubeWithText:[self attributedStringWithTitle:NSLocalizedString(@"DIESEL", nil) price:[[array lastObject] objectForKey:@"priceG"]] color:[UIColor colorWithRed:0.118 green:0.132 blue:0.160 alpha:1.000] origin:CGPointMake(SQUARE_SIZE*2, priceStationDesc.y)];
                [scrollview addSubview:priceDiesel];
                [self animateCube:priceDiesel];
                
                [graph removeFromSuperview]; graph=nil;
                graph=[[MPGraphView alloc] initWithFrame:CGRectMake(0, priceStationDesc.y+SQUARE_SIZE*2+25, self.view.width, 60)];
                if(corseData)
                graph.avgvalues=[corseData objectForKey:@"gasoline"];
                [scrollview addSubview:graph];
                
                [graph2 removeFromSuperview]; graph2=nil;
                graph2=[[MPGraphView alloc] initWithFrame:CGRectMake(0, priceStationDesc.y+SQUARE_SIZE*2+25, self.view.width, 60)];
                graph2.values=gasoline;
                [scrollview addSubview:graph2];

                
                [gasStatsButton removeFromSuperview]; gasStatsButton=nil;

                gasStatsButton=[UIButton buttonWithType:UIButtonTypeCustom];
                gasStatsButton.frame=CGRectMake(10,graph.y+graph.height+10, 130, 45);
                [gasStatsButton setBackgroundColor:[UIColor clearColor]];
                gasStatsButton.layer.cornerRadius=3;
                gasStatsButton.layer.borderColor=[UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000].CGColor;
                gasStatsButton.layer.borderWidth=2;
                [gasStatsButton setTitle:NSLocalizedString(@"GASOLINE", nil) forState:UIControlStateNormal];
                [gasStatsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [gasStatsButton setTitleColor:[UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000] forState:UIControlStateHighlighted];
                [[gasStatsButton titleLabel] setFont:[UIFont berlinBoldFontWithSize:22]];
                [gasStatsButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
                [gasStatsButton addTarget:self action:@selector(showStats:) forControlEvents:UIControlEventTouchUpInside];
                [scrollview addSubview:gasStatsButton];
                
                [dieselStatsButton removeFromSuperview]; dieselStatsButton=nil;

                dieselStatsButton=[UIButton buttonWithType:UIButtonTypeCustom];
                dieselStatsButton.frame=CGRectMake(self.view.width-10-130,graph.y+graph.height+10, 130, 45);
                [dieselStatsButton setBackgroundColor:[UIColor clearColor]];
                dieselStatsButton.layer.cornerRadius=3;
                dieselStatsButton.layer.borderColor=[UIColor colorWithRed:0.148 green:0.171 blue:0.218 alpha:1.000].CGColor;
                dieselStatsButton.layer.borderWidth=2;
                [dieselStatsButton setTitle:NSLocalizedString(@"DIESEL", nil) forState:UIControlStateNormal];
                [dieselStatsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [dieselStatsButton setTitleColor:[UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000] forState:UIControlStateHighlighted];
                [[dieselStatsButton titleLabel] setFont:[UIFont berlinBoldFontWithSize:22]];
                [dieselStatsButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
                [dieselStatsButton addTarget:self action:@selector(showStats:) forControlEvents:UIControlEventTouchUpInside];
                [scrollview addSubview:dieselStatsButton];
                
                scrollview.contentSize=CGSizeMake(self.view.width, dieselStatsButton.y+dieselStatsButton.height+20);


                
            });
        });
    }];
    
    [MPOpenDataWrapper requestFromCorsicanPortalGasStationsStatsWithCount:10 cursor:0 orderBy:@"date" otherParams:nil complentionHandler:^(NSDictionary *dict) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
        NSArray *values=[dict objectForKey:@"records"];
        
        NSMutableArray *gasoline=[[NSMutableArray alloc] init];
        NSMutableArray *diesel=[[NSMutableArray alloc] init];
        NSMutableArray *dates=[[NSMutableArray alloc] init];
        for (NSDictionary* val in values) {
         
            [gasoline addObject:[[val objectForKey:@"fields"] objectForKey:@"sp95"]];
            [diesel addObject:[[val objectForKey:@"fields"] objectForKey:@"gazole"]];
            [dates addObject:[[val objectForKey:@"fields"] objectForKey:@"date"]];
        }
        
        corseData=[@{@"gasoline": gasoline,@"diesel":diesel,@"dates":dates} mutableCopy];
            
            if (graph) {
                graph.avgvalues=[corseData objectForKey:@"gasoline"];
            }
           
            for (NSInteger i=0; i<gasoline.count; i++) {
                avgDCorse+=[[diesel objectAtIndex:i] floatValue];
                avgGCorse+=[[gasoline objectAtIndex:i] floatValue];
            }
            
            avgDCorse/=diesel.count;
            avgGCorse/=gasoline.count;
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                
                averageCorseDesc=[self createCubeWithText:@"%\nAVERAGE\n(DISTRICT)" color:[UIColor colorWithRed:252.0/255.0 green:83.0/255.0 blue:23.0/255.0 alpha:1.000] origin:CGPointMake(0, 60*2+desc.height+SQUARE_SIZE)];
                [scrollview addSubview:averageCorseDesc];
                [self animateCube:averageCorseDesc];
                
                priceGasolineC=[self createCubeWithText:[self attributedStringWithTitle:NSLocalizedString(@"AVG. GASOLINE", nil) price:[NSString stringWithFormat:@"%.3f",avgGCorse]] color:[UIColor colorWithRed:0.118 green:0.132 blue:0.160 alpha:1.000] origin:CGPointMake(SQUARE_SIZE, averageCorseDesc.y)];
                [scrollview addSubview:priceGasolineC];
                [self animateCube:priceGasolineC];
                
                priceDieselC=[self createCubeWithText:[self attributedStringWithTitle:NSLocalizedString(@"AVG. DIESEL", nil) price:[NSString stringWithFormat:@"%.3f",avgDCorse]] color:[UIColor colorWithRed:0.148 green:0.171 blue:0.218 alpha:1.000] origin:CGPointMake(SQUARE_SIZE*2, averageCorseDesc.y)];
                [scrollview addSubview:priceDieselC];
                [self animateCube:priceDieselC];
                
            });
        });
        
    }];
    
}

- (void)new:(id)sender{
    
    MPSubmitViewController* submit=[[MPSubmitViewController alloc] init];
    submit.venue=self.venue;
    [self.navigationController pushViewController:submit animated:YES];
    
}


-(void)showStats:(id)sender{
    
    //placedata=[@{@"gasoline": gasoline,@"diesel":diesel,@"dates":dates} mutableCopy];
    //corseData=[@{@"gasoline": gasoline,@"diesel":diesel,@"dates":dates} mutableCopy];

    [UIView animateWithDuration:.2 animations:^{
        
        if (sender==gasStatsButton) {
            dieselStatsButton.layer.borderColor=[UIColor colorWithRed:0.148 green:0.171 blue:0.218 alpha:1.000].CGColor;
            gasStatsButton.layer.borderColor=[UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000].CGColor;
            
            graph.avgvalues=[corseData objectForKey:@"gasoline"];
            graph2.values=[placedata objectForKey:@"gasoline"];

        }else{
            
            gasStatsButton.layer.borderColor=[UIColor colorWithRed:0.148 green:0.171 blue:0.218 alpha:1.000].CGColor;
            dieselStatsButton.layer.borderColor=[UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000].CGColor;

            graph.avgvalues=[corseData objectForKey:@"diesel"];
            graph2.values=[placedata objectForKey:@"diesel"];

        }
        
    }];

}

- (NSAttributedString *)attributedStringWithTitle:(NSString *)title price:(NSString *)price{
    
    price=[price stringByReplacingOccurrencesOfString:@"." withString:@","];
    
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@\n\n%@",title, NSLocalizedString(@"Price / L", nil),price] attributes:@{NSFontAttributeName : [UIFont berlinBoldFontWithSize:14],NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [attr addAttributes:@{NSFontAttributeName : [UIFont berlinFontWithSize:34],NSForegroundColorAttributeName : [UIColor whiteColor]} range:[[attr string] rangeOfString:price]];

    
    return attr;
}


- (UILabel *)createCubeWithText:(id)text color:(UIColor *)color origin:(CGPoint)origin{
    
    UILabel *cube=[[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, SQUARE_SIZE, SQUARE_SIZE)];

    cube.backgroundColor=color;
    cube.font=[UIFont berlinFontWithSize:14];

    if([text isKindOfClass:[NSString class]])
        cube.text=text;
    else cube.attributedText=text;
    cube.numberOfLines=0;
    cube.textColor=[UIColor whiteColor];
    cube.transform=CGAffineTransformMakeScale(0, 0);
    cube.textAlignment=NSTextAlignmentCenter;
    
    return cube;
}


- (void)animateCube:(UIView *)cube{
    
    [UIView animateWithDuration:.2 animations:^{
        cube.transform=CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            cube.transform=CGAffineTransformMakeScale(.9, .9);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                cube.transform=CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL finished) {
                
            }];
        }];
    }];
    
}

@end
