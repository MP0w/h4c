//
//  MPGraphView.m
//  h4c
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPGraphView.h"

@interface MPButton : UIButton

@end

@implementation MPButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return CGRectContainsPoint(CGRectInset(self.bounds, -25, -35), point);
    
}

@end

@implementation MPGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        
        
    }
    return self;
}

//            placedata=[@{@"gasoline": gasoline,@"diesel":diesel,@"dates":dates} mutableCopy];


-(void)setAvgvalues:(NSArray *)values{
    
    if(values){
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:252.0/255.0 green:83.0/255.0 blue:23.0/255.0 alpha:1.000] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:145.0/255.0 blue:25.0/255.0 alpha:1.000] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];

        _avgvalues=[values copy];
        
        [self setNeedsDisplay];
    }
}

- (void)setValues:(NSArray *)values{
    
    if (values) {
        
        _values=[values copy];
        
        [self setNeedsDisplay];
    }
    
}

- (NSArray *)reversedArray:(NSArray *)array_{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[array_ count]];
    NSEnumerator *enumerator = [array_ reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.avgvalues.count) {

        
        NSArray *dict= self.avgvalues.count>7 ? [self.avgvalues subarrayWithRange:NSMakeRange(self.avgvalues.count-7, 7)] : self.avgvalues;
        
        NSMutableArray *points=[self pointsForArray:dict];
        
        CGFloat space=rect.size.width/(dict.count-1);
        CGFloat offset=10;

        
        UIBezierPath *path=[UIBezierPath bezierPath];
        
        NSInteger i=0;
        
        [path moveToPoint:CGPointMake(0,self.height)];

        
        for (NSNumber *pointY in points) {
           
            CGPoint point=CGPointMake((space+offset)*i,self.height-((self.height-offset*2)*[pointY floatValue]+offset));
            [path addLineToPoint:point];
            i++;
            
        }
        
        [path addLineToPoint:CGPointMake(self.width, self.height)];

        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;

        self.layer.mask=maskLayer;
    
    }
    
    
    if (self.values.count && !self.avgvalues) {
        
        [label removeFromSuperview]; label=nil;

        for (UIButton* button in buttons) {
            [button removeFromSuperview];
        }
        
        
        NSArray *dict= self.values.count>7 ? [self.values subarrayWithRange:NSMakeRange(self.values.count-7, 7)] : self.values;
        
        NSMutableArray *points=[self pointsForArray:dict];
        
        CGFloat space=dict.count>1  ?  (rect.size.width-10)/(dict.count-1) : rect.size.width/2-5;
        CGFloat offset=10;
        
        
        UIBezierPath *path=[UIBezierPath bezierPath];
        
        NSInteger i=0;
        
        [path moveToPoint:CGPointMake(-2,self.height)];
        
        buttons=[[NSMutableArray alloc] init];
        
        
        for (NSNumber *pointY in points) {
            
            CGPoint point=CGPointMake(5+(space)*i + (dict.count==1 ? space : 0),self.height-((self.height-offset*2)*[pointY floatValue]+offset));
            
            MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.cornerRadius=3;
            button.frame=CGRectMake(0, 0, 6, 6);
            button.center=point;
            [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [self addSubview:button];
            
            [buttons addObject:button];
            
            [path addLineToPoint:point];
            i++;
            
        }
        
        [path addLineToPoint:CGPointMake(self.width+2, self.height)];
        
        [[UIColor whiteColor] setStroke];
        
        path.lineWidth=1;
        [path stroke];

    }
}


- (void)tap:(UIButton *)button{
    
    [label removeFromSuperview]; label=nil;
    
    label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    label.backgroundColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    
    NSArray *dict= self.values.count>7 ? [self.values subarrayWithRange:NSMakeRange(self.values.count-7, 7)] : self.values;

    label.text=[NSString stringWithFormat:@"%.3f",[[dict objectAtIndex:button.tag] floatValue]];
    label.center=CGPointMake(button.center.x<label.width/2 ? label.width/2+2 : (button.center.x>self.width-label.width/2 ? self.width-label.width/2 -2 : button.center.x),button.center.y);
    label.layer.cornerRadius=3;
    label.clipsToBounds=YES;
    label.transform=CGAffineTransformMakeScale(0, 0);
    [self addSubview:label];
    [UIView animateWithDuration:.2 animations:^{
        label.transform=CGAffineTransformMakeScale(1, 1);
    }];
    
    
}


- (NSMutableArray *)pointsForArray:(NSArray *)dict{
   
    CGFloat min,max,avg;
    
    min=max=[[dict firstObject] floatValue];
    
    
    for (NSInteger i=0; i<dict.count; i++) {
        
        CGFloat val=[[dict objectAtIndex:i] floatValue];
        
        if (val>max) {
            max=val;
        }
        
        if (val<min) {
            min=val;
        }
        
        avg+=val;
    }
    
    avg/=dict.count;
    
    
    NSMutableArray *points=[[NSMutableArray alloc] init];
    
    if(max!=min){
        for (NSString *p in dict) {
            
            CGFloat val=[p floatValue];
            
            val=((val-min)/(max-min));
            
            [points addObject:@(val)];
        }
        
    }else [points addObject:@(1)];

    return points;
}

@end
