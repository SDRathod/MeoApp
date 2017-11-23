//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface REVClusterPin : NSObject  <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    int intPinId;
    NSArray *nodes;
    NSDictionary *dictObj;
    
}
@property(nonatomic, retain) NSArray *nodes;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) int intPinId;
@property (nonatomic, retain) NSDictionary *dictObj;

- (NSUInteger) nodeCount;

@end