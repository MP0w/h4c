
#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface PlaceOfInterest : NSObject

@property (nonatomic) UIView *view;
@property (nonatomic) CLLocation *location;

+ (PlaceOfInterest *)placeOfInterestWithView:(UIView *)view at:(CLLocation *)location;

@end
