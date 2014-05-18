
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

#import "MPPointDescView.h"


@interface ARView : UIView  <CLLocationManagerDelegate> {
    __weak UIButton *clicked;
    
    CGRect orig;
}

@property (nonatomic) NSArray *placesOfInterest;

- (void)start;
- (void)stop;

@end
