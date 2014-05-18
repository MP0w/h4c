//
//  MPNumberView.m
//  h4c
//
//  Created by Alex Manzella on 17/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPNumberView.h"

#define PADDING 3

@implementation MPNumberView

- (id)initWithFrame:(CGRect)frame min:(NSInteger)min_ max:(NSInteger)max_ defaultValue:(NSInteger)defaultValue_
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.clipsToBounds=NO;
        
        min=min_;
        max=max_;
        def=defaultValue_;
        
        self.backgroundColor=[UIColor blackColor];
        
        numbersView=[[NSMutableDictionary alloc] init];
        
        for (NSInteger i=min; i<=max_; i++) {
            
            [numbersView setObject:[[MPSubNumberView alloc] initWithFrame:self.bounds value:i] forKey:@(i)];
            [self addSubview:[numbersView objectForKey:@(i)]];
            
        }
        
        current=[[MPSubNumberView alloc] initWithFrame:self.bounds value:def];
        
        [self addSubview:current];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self expand];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint tappedPt = [[touches anyObject] locationInView: self];

    CGPoint tappedSuper = [[touches anyObject] locationInView: self.superview.superview];
    
    CGFloat y=tappedPt.y;
    

    
    NSInteger index;
    
    if (y<0) {
         index = def-( (-y/(self.height+PADDING)));
        
        
    }else if (y>self.height){
         index =def + (y/(self.height+PADDING));

    }
    
    if (tappedSuper.y<self.height+44 && index!=0) {
        [self shift:YES];
    }else if (tappedSuper.y>self.superview.superview.height-self.height && index!=9){
        [self shift:NO];
    }
    
    if(currentselected!=[numbersView objectForKey:@(index)])
    currentselected.transform=CGAffineTransformMakeScale(1, 1);
    
    currentselected=[numbersView objectForKey:@(index)];
    
    if(currentselected.transform.a==1){
        [UIView animateWithDuration:.15 animations:^{
            currentselected.transform=CGAffineTransformMakeScale(1.5, 1.5);
        }];
    }
    

    
}

- (void)shift:(BOOL)up{
    
    NSInteger value=current.value+(up ? -1 : 1);
    
    if (value<min || value>max) {
        return;
    }
    
    [current setValue:value];
    def+=(up ? -1 : 1);
    
    for (NSString* key in numbersView.allKeys) {
        
        
        NSInteger index=[key integerValue];
        MPSubNumberView *view=[numbersView objectForKey:key];
        

        
        [UIView animateWithDuration:.2 animations:^{
            view.y+=(PADDING+self.height)*(up ? 1 : -1);
        }];
        
        
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self collapse];
}

-(void)expand{
    
    CGFloat h=self.height;
    
    
    for (NSString* key in numbersView.allKeys) {
        
        
        NSInteger index=[key integerValue];
        MPSubNumberView *view=[numbersView objectForKey:key];
        

        
        [UIView animateWithDuration:.2 animations:^{
            if (index<def) {
                view.y=-(h+PADDING)*(def-index);
            }else{
                view.y=(h+PADDING)*(index-def);
                
            }
        }];
        
        
    }
    
    
    
}

- (NSInteger)value{
    return current.value;
}

-(void)collapse{
    
    [self.superview.superview touchesEnded:nil withEvent:nil];
    
    currentselected.transform=CGAffineTransformMakeScale(1, 1);

    for (NSString* key in numbersView.allKeys) {
        
        
        NSInteger index=[key integerValue];
        MPSubNumberView *view=[numbersView objectForKey:key];
        
        if (view==currentselected) {
            stopIndex=index;
        }
        
        [UIView animateWithDuration:.2 animations:^{
            view.y=0;
        }];
        
        
    }
    if (currentselected) {
        currentselected=nil;
        def=stopIndex;
        [current setValue:stopIndex];
    }
}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    
    
    return CGRectContainsPoint(CGRectMake(0, -1000, self.width, 10000), point);
}

@end
