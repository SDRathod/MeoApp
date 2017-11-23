//
// DemoTableFooterView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>


@interface DemoTableFooterView : UICollectionReusableView {
    
  UIActivityIndicatorView *activityIndicator;
  UILabel *infoLabel;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;

@end
