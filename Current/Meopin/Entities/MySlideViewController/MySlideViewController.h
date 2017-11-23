//
//  MySlideViewController.h
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "SlideViewController.h"

@interface MySlideViewController : SlideViewController <SlideViewControllerDelegate> {
    
    NSArray *_datasource;
    
}

@property (nonatomic, readonly) NSArray *datasource;


-(void) addDynamicDataSource;

@end
