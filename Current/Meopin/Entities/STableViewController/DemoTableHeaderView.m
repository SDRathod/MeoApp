//
// DemoTableHeaderView.m
//
// @author Shiki
//

#import "DemoTableHeaderView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DemoTableHeaderView

@synthesize arrowImage;
@synthesize title;
@synthesize activityIndicator;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor redColor];
    
    CALayer *layer = [CALayer layer];
    
    layer.frame = CGRectMake(30.0f, 5.0f , 15.0f, 25.0f);
    title.frame = CGRectMake(20.0f,8.0f,[UIScreen mainScreen].bounds.size.width-40,21.0f);
    title.font=[UIFont fontWithName:@"Helvetica" size:13];
    activityIndicator.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width-20)/2, 25.0f , 20.0f, 20.0f);
    
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed:@"imgRefreshArrow.png"].CGImage;
    [[self layer] addSublayer:layer];
    arrowImage=layer;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

@end
