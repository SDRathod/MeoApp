//
// DemoTableHeaderView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>


@interface DemoTableHeaderView : UIView {
    CALayer *arrowImage;
    UILabel *title;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet CALayer *arrowImage;
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
