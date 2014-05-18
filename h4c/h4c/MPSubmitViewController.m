//
//  MPSubmitViewController.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPSubmitViewController.h"

#define TR_H 160

UIView *blackify;

@interface MPView : UIView

@end

@implementation MPView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view=[super hitTest:point withEvent:event];
    
    if ([view isKindOfClass:[MPSubNumberView class]]) {
        
        [view.superview.superview.superview bringSubviewToFront:view.superview.superview];
        [view.superview.superview.superview insertSubview:blackify belowSubview:view.superview.superview];
        
    }else if(blackify.superview){
        [blackify removeFromSuperview];
    }
    
    return view;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    if(blackify.superview){
        [blackify removeFromSuperview];
    }
}

@end

@interface MPSubmitViewController ()

@end

@implementation MPSubmitViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    
    [super loadView];
    self.view=[[MPView alloc] initWithFrame:[self view].frame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIBarButtonItem* new=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", nil) style:UIBarButtonItemStylePlain target:self action:@selector(send)];
//    [self.navigationItemsetRightBarButtonItem:new];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[CACHEDIR stringByAppendingPathComponent:self.venue.placeId]]){
        
        UIImageView *bg=[[UIImageView alloc] initWithFrame:self.view.bounds];
        bg.alpha=.05;
        bg.backgroundColor=[UIColor clearColor];
        bg.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:[CACHEDIR stringByAppendingPathComponent:self.venue.placeId]]];
        [self.view addSubview:bg];
        
    }
    
    blackify=[[UIView alloc] initWithFrame:self.view.bounds];
    blackify.backgroundColor=[UIColor colorWithWhite:0 alpha:.75];

    self.view.backgroundColor=[UIColor colorWithRed:38.0/255.0 green:45.0/255.0 blue:55.0/255.0 alpha:1];
    
    desc=[[UILabel alloc] initWithFrame:CGRectMake(55, 100, self.view.width-110, 100)];
    
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"The current price in %@ is:", nil),self.venue.name] attributes:@{NSFontAttributeName : [UIFont berlinFontWithSize:20],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [attr addAttributes:@{NSFontAttributeName : [UIFont berlinItalicFontWithSize:20],NSForegroundColorAttributeName : [UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000]} range:[[attr string] rangeOfString:self.venue.name]];
    desc.attributedText=attr;
    desc.numberOfLines=0;
    [self.view addSubview:desc];
    
    [desc sizeToFit];
    
    UIView *transp=[[UIView alloc] initWithFrame:CGRectMake(0, (self.view.height-TR_H)/2+22, self.view.width, TR_H)];
    transp.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.150];
    [self.view addSubview:transp];
    
    
    UILabel* price1=[[UILabel alloc] initWithFrame:CGRectMake(0, transp.y,105, 80)];
    price1.textColor=[UIColor whiteColor];
    price1.font=[UIFont berlinFontWithSize:25];
    price1.numberOfLines=2;
    price1.text=NSLocalizedString(@"Gasoline\n/L", nil);
    price1.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:price1];
    
    UILabel* price2=[[UILabel alloc] initWithFrame:CGRectMake(0, price1.y+price1.height, price1.width, 80)];
    price2.textColor=[UIColor whiteColor];
    price2.font=[UIFont berlinFontWithSize:25];
    price2.numberOfLines=2;
    price2.textAlignment=NSTextAlignmentRight;
    price2.text=NSLocalizedString(@"Diesel\n/L", nil);
    [self.view addSubview:price2];
    
    NSInteger priceG[4]={1,5,5,5};
    NSInteger priceD[4]={1,5,5,5};

    
    if (self.venue.priceD>0) {
        
        NSInteger expanded=(NSInteger)(self.venue.priceD*1000);
        const char *price=[[NSString stringWithFormat:@"%li",(long)expanded] UTF8String];
        priceD[0]=[[NSString stringWithFormat:@"%c",price[0]] integerValue];
        priceD[1]=[[NSString stringWithFormat:@"%c",price[1]] integerValue];
        priceD[2]=[[NSString stringWithFormat:@"%c",price[2]] integerValue];
        priceD[3]=[[NSString stringWithFormat:@"%c",price[3]] integerValue];
    }

    if (self.venue.priceG>0) {
        
        NSInteger expanded=(NSInteger)(self.venue.priceG*1000);
        const char *price=[[NSString stringWithFormat:@"%li",(long)expanded] UTF8String];
        priceG[0]=[[NSString stringWithFormat:@"%c",price[0]] integerValue];
        priceG[1]=[[NSString stringWithFormat:@"%c",price[1]] integerValue];
        priceG[2]=[[NSString stringWithFormat:@"%c",price[2]] integerValue];
        priceG[3]=[[NSString stringWithFormat:@"%c",price[3]] integerValue];
    }
    
    pickerG=[[MPNumberPicker alloc] initWithNumberOfColumns:4 defaultValues:@[@(priceG[0]),@(priceG[1]),@(priceG[2]),@(priceG[3])] frame:CGRectMake(price1.x+price1.width+15, price1.y+15, 200, 50) maxValues:@[@(2),@(9),@(9),@(9)] minValues:@[@(0),@(0),@(0),@(0)]];
    [self.view addSubview:pickerG];

    pickerD=[[MPNumberPicker alloc] initWithNumberOfColumns:4 defaultValues:@[@(priceD[0]),@(priceD[1]),@(priceD[2]),@(priceD[3])] frame:CGRectMake(price2.x+price2.width+15, price2.y+15, 200, 50) maxValues:@[@(2),@(9),@(9),@(9)] minValues:@[@(0),@(0),@(0),@(0)]];
    [self.view addSubview:pickerD];
    
    UILabel *comma=[[UILabel alloc] initWithFrame:CGRectMake(pickerG.x+37, pickerG.y+26, 20, 25)];
    comma.text=@",";
    comma.font=[UIFont berlinBoldFontWithSize:33];
    comma.textColor=[UIColor whiteColor];
    [self.view addSubview:comma];
    
    UILabel *comma2=[[UILabel alloc] initWithFrame:CGRectMake(pickerD.x+37, pickerD.y+26, 20, 25)];
    comma2.text=@",";
    comma2.font=[UIFont berlinBoldFontWithSize:33];
    comma2.textColor=[UIColor whiteColor];
    [self.view addSubview:comma2];
    
    updateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    updateButton.frame=CGRectMake((self.view.width-130)/2,transp.y+transp.height+(self.view.height-(transp.y+transp.height)-45)/2, 130, 45);
    [updateButton setBackgroundColor:[UIColor clearColor]];
    updateButton.layer.cornerRadius=3;
    updateButton.layer.borderColor=[UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000].CGColor;
    updateButton.layer.borderWidth=2;
    [updateButton setTitle:NSLocalizedString(@"UPDATE", nil) forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor colorWithRed:0.899 green:0.497 blue:0.205 alpha:1.000] forState:UIControlStateHighlighted];
    [[updateButton titleLabel] setFont:[UIFont berlinBoldFontWithSize:25]];
    [updateButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    [updateButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title{
    return NSLocalizedString(@"Submit Prices", nil);
}

- (void)send{
    
    NSInteger valueG=[pickerG value];
    NSInteger valueD=[pickerD value];
    
    [MPOpenDataWrapper sendPlaceInfoForPoint:self.venue.location message:nil placeId:self.venue.placeId productsPrices:@{@"priceB":[NSString stringWithFormat:@"%.3f",(CGFloat)(valueG/1000.0)],@"priceG":[NSString stringWithFormat:@"%.3f",(CGFloat)(valueD/1000.0)]} complentionHandler:^(BOOL success, NSDictionary *dict) {
        
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }else [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Prices not sent", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }];
    
}

@end
