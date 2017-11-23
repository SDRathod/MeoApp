//
//  SlideViewController.m
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "SlideViewController.h"
#import "SlideViewCustomCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "Meopin-Swift.h"

#define kSVCLeftAnchorX                 100.0f
#define kSVCRightAnchorX                190.0f
#define kSVCSwipeNavigationBarOnly      YES

@class AppDelegate;
@class ProviderSchedulingVC;

@interface SlideViewNavigationBar : UINavigationBar {
    @private
    
    id <SlideViewNavigationBarDelegate> slideViewNavigationBarDelegate;
    
}
    
    @property (nonatomic, assign) id <SlideViewNavigationBarDelegate> slideViewNavigationBarDelegate;
    @end

@implementation SlideViewNavigationBar
    
    @synthesize slideViewNavigationBarDelegate = _slideViewNavigationBarDelegate;
    
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesBegan:touches withEvent:event];
    
}
    
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesMoved:touches withEvent:event];
}
    
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesEnded:touches withEvent:event];
}
    
    @end

@interface SlideViewTableCell : UITableViewCell {
    @private
    
}
    @end

@implementation SlideViewTableCell
    
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    
    return self;
}
    
- (void)layoutSubviews {
    [super layoutSubviews];
}
    
    @end

@interface SlideViewController() <SingletonDelegate> {
    
}
@end

@implementation SlideViewController
    
    @synthesize intUnreadChatMsgCount;
    @synthesize delegate,_tableView;// = _delegate;
    
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
    {
        NSString *strNib = @"SlideViewController" ;
        self = [super initWithNibName:strNib bundle:nil];
        
        if (self) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 26, 25);
            [btn setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(menuBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn setShowsTouchWhenHighlighted:YES];
            
            _touchView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
            _touchView.exclusiveTouch = NO;
            _touchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 768.0f, 960.0f)];
            
            _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        }
        return self;
    }
    
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
    
    
#pragma mark - View Lifecycle
    
- (void)viewDidLoad {
    [(SlideViewNavigationBar *)_slideNavigationController.navigationBar setSlideViewNavigationBarDelegate:self];
    
    UIViewController *initalViewController = [self.delegate initialViewController];
    [self configureViewController:initalViewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:initalViewController] animated:NO];
    
    [self addChildViewController:_slideNavigationController];
    
    [self.view addSubview:_slideNavigationController.view];
    
    if ([self.delegate respondsToSelector:@selector(initialSelectedIndexPath)])
    [_tableView selectRowAtIndexPath:[self.delegate initialSelectedIndexPath] animated:NO scrollPosition:UITableViewScrollPositionTop];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //    [self.view addGestureRecognizer:tap];
    
    btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogout.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width * 235) / 320, (([UIScreen mainScreen].bounds.size.width * 45) / 320));
    [btnLogout setTitle:LocalizedString(@"keySlLogOut", nil) forState:UIControlStateNormal];
    [btnLogout setTitleColor:[UIColor colorWithRed:255.0/255.0 green:58.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnLogout.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:12]];
    [btnLogout addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    self._tableView.tableFooterView = btnLogout;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"101" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayHomePageFromAnyView) name:@"101" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"102" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displaySearchScreenFromAnyView) name:@"102" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"103" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayDashboardPageFromAnyView) name:@"103" object:nil];
}
    
-(void)viewDidLayoutSubviews {
}
    
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    lblAppTitle.text = LocalizedString(@"keySlMyMeopin", nil);
    
    lblAppTitle.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:(([UIScreen mainScreen].bounds.size.width * 17) / 320)];
    btnCloseMenu.titleLabel.font = [UIFont fontWithName:@"Meopin_TOPS" size:(([UIScreen mainScreen].bounds.size.width * 16) / 320)];
}
   
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
}
    
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
  
#pragma mark -
#pragma mark Scroll Language delegate Methods
    
-(void) didSelectLanguage {
    lblAppTitle.text = LocalizedString(@"keySlMyMeopin", nil);
    [btnLogout setTitle:LocalizedString(@"keySlLogOut", nil) forState:UIControlStateNormal];
    [_tableView reloadData];
}
    
#pragma mark -
#pragma mark notification Methods
    
-(void) displayHomePageFromAnyView {
    NSDictionary *viewControllerDictionary = nil;
    
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"])
    viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:1];
    else
    viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:0];
    
    Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideVCClassKey];
    NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideVCNibNameKey];
    UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
    
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
    [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
    
    [self configureViewController:viewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    [self slideInSlideNavigationControllerView];
}
    
-(void) displayDashboardPageFromAnyView {
    NSDictionary *viewControllerDictionary = nil;
        
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"])
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:1];
    else
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:0];
        
    Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideVCClassKey];
    NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideVCNibNameKey];
    UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
        
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
        [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
        
    [self configureViewController:viewController];
        
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    [self slideInSlideNavigationControllerView];
}
    
-(void) displaySearchScreenFromAnyView {
    NSDictionary *viewControllerDictionary = nil;
    
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
        if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserRole"] isEqualToString:@"1"]) {
            viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:3];
            
            Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideVCClassKey];
            NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideVCNibNameKey];
            UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
            
            if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
            [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
            
            [self configureViewController:viewController];
            
            [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
            [self slideInSlideNavigationControllerView];
        }
    }
    else {
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:1];
        
        Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideVCClassKey];
        NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideVCNibNameKey];
        UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
        
        if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
        [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
        
        [self configureViewController:viewController];
        
        [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
        [self slideInSlideNavigationControllerView];
    }
}
    
#pragma mark Instance Methods
    
- (void)configureViewController:(UIViewController *)viewController {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnSideMenuOpen.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(menuBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
    
- (void)menuBarButtonItemPressed:(id)sender {
    if (_slideNavigationControllerState == kSlideNavigationControllerStatePeeking) {
        [self slideInSlideNavigationControllerView];
        return;
    }
    
    UIViewController *currentViewController = [[_slideNavigationController viewControllers] objectAtIndex:0];
    if ([currentViewController conformsToProtocol:@protocol(SlideViewControllerSlideDelegate)] && [currentViewController respondsToSelector:@selector(shouldSlideOut)]) {
        
        if ([(id <SlideViewControllerSlideDelegate>)currentViewController shouldSlideOut]) {
            [self slideOutSlideNavigationControllerView];
        }
        
    } else {
        [self slideOutSlideNavigationControllerView];
    }
}
    
- (void)slideOutSlideNavigationControllerView {
    _slideNavigationControllerState = kSlideNavigationControllerStatePeeking;
    
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(([UIScreen mainScreen].bounds.size.width * 235) / 320, 0.0f);
    } completion:^(BOOL finished) {
        [_slideNavigationController.view addSubview:_overlayView];
        
    }];
    [_tableView reloadData];
    _tableView.contentOffset = CGPointMake(0, 0);
    
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
        btnLogout.hidden = false;
    }
    else {
        btnLogout.hidden = true;
    }
    
    [Singleton sharedSingleton].delegate = self;
    [[Singleton sharedSingleton] addLanguageScrollViewForSlideMenuInView:viewLanguages with:CGRectMake(0, ([UIScreen mainScreen].bounds.size.width * 1) / 320, ([UIScreen mainScreen].bounds.size.width * 235) / 320, ([UIScreen mainScreen].bounds.size.width * 30) / 320) textColor:[UIColor colorWithRed:126.0/255.0 green:162.0/255.0 blue:209.0/255.0 alpha:1.0] selTextColor:[UIColor whiteColor]];
    
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
        AppDelegate *appDel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserRole"] isEqualToString:@"1"]) { //patient
            [appDel getSlideMenuPatientCountCall];
        }
        else {
            [appDel getSlideMenuProviderCountCall];
        }
    }
}
    
- (void)slideInSlideNavigationControllerView {
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        [_overlayView removeFromSuperview];
        
    }];
    
    [Singleton sharedSingleton].delegate = nil;
    [[Singleton sharedSingleton] removeLanguageScrollViewForSlideMenu];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"105" object:nil];
}
    
- (void)slideSlideNavigationControllerViewOffScreen {
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(320.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        
        [_slideNavigationController.view addSubview:_overlayView];
        
    }];
}
    
#pragma mark UITouch Logic
    
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    _startingDragPoint = [touch locationInView:self.view];
    
    if ((CGRectContainsPoint(_slideNavigationController.view.frame, _startingDragPoint)) && _slideNavigationControllerState == kSlideNavigationControllerStatePeeking) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;
    }
    
    // we only trigger a swipe if either navigationBarOnly is deactivated
    // or we swiped in the navigationBar
    if (!kSVCSwipeNavigationBarOnly || _startingDragPoint.y <= 44.0f) {
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;
    }
}
    
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_slideNavigationControllerState != kSlideNavigationControllerStateDragging)
    return;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
    [UIView animateWithDuration:0.05f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(MAX(_startingDragTransformTx + (location.x - _startingDragPoint.x), 0.0f), 0.0f);
        
    } completion:^(BOOL finished) {
        
    }];
}
    
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateDragging) {
        UITouch *touch = [touches anyObject];
        CGPoint endPoint = [touch locationInView:self.view];
        
        // Check in which direction we were dragging
        if (endPoint.x < _startingDragPoint.x) {
            if (_slideNavigationController.view.transform.tx <= kSVCRightAnchorX) {
                [self slideInSlideNavigationControllerView];
            } else {
                [self slideOutSlideNavigationControllerView];
            }
        } else {
            if (_slideNavigationController.view.transform.tx >= kSVCLeftAnchorX) {
                [self slideOutSlideNavigationControllerView];
            } else {
                [self slideInSlideNavigationControllerView];
            }
        }
    }
}
    
#pragma mark SlideViewNavigationBarDelegate Methods
    
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBegan:touches withEvent:event];
}
    
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}
    
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}
    
#pragma mark UINavigationControlerDelgate Methods
    
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([[navigationController viewControllers] count] > 1) {
        _slideNavigationControllerState = kSlideNavigationControllerStateDrilledDown;
    } else {
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
    }
}
    
#pragma mark UITableViewDelegate / UITableViewDatasource Methods
    
    //- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"])
    //        return 0; //(([UIScreen mainScreen].bounds.size.width * 55) / 320);
    //    else
    //        return 0;
    //}
    //
    //- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
    //        UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    //        btnLogout.frame = CGRectMake(0, 20, ([UIScreen mainScreen].bounds.size.width * 235) / 320, (([UIScreen mainScreen].bounds.size.width * 35) / 320));
    //        [btnLogout setTitle:LocalizedString(@"keySlLogOut", nil) forState:UIControlStateNormal];
    //        [btnLogout setTitleColor:[UIColor colorWithRed:255.0/255.0 green:58.0/255.0 blue:47.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    //        [btnLogout.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:12]];
    //        [btnLogout addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    //        return btnLogout;
    //    }
    //    else
    //        return nil;
    //
    //}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (([UIScreen mainScreen].bounds.size.width * 44) / 320);
}
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.delegate datasource].count;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[self.delegate datasource] objectAtIndex:section] objectForKey:kSlideVCSectionVCKey] count];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    CellIdentifier = @"SlideViewCustomCell";
    
    SlideViewCustomCell *cell = (SlideViewCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)	{
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.showsReorderControl = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell setLanguageTitles];
    
    NSMutableDictionary *viewControllerDictionary = nil;
    viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideVCSectionVCKey] objectAtIndex:indexPath.row];
    
    cell.imgProPic.hidden = true;
    cell.lblCount.hidden = true;
    cell.lblArrow.hidden = false;
    cell.lblSearch.hidden = true;
    
    cell.lblTitle.text = LocalizedString([viewControllerDictionary objectForKey:kSlideVCTitleKey], nil);
    
    cell.lblTitle.textColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"] && indexPath.row == 0) {
        cell.imgProPic.hidden = false;
        cell.lblArrow.hidden = true;
        
        [cell.imgProPic setImageWithURL:[NSURL URLWithString:[[Singleton sharedSingleton] retriveFromUserDefaultsWithKey:@"meopinUserProfilePic"]] placeholderImage:[UIImage imageNamed:@"ProfileView"]];
        //
        cell.imgProPic.layer.masksToBounds = true;
        cell.imgProPic.layer.cornerRadius = (((([UIScreen mainScreen].bounds.size.width * 44) / 320) - 19) / 2);
        cell.imgProPic.layer.borderWidth = 0.5;
        cell.imgProPic.layer.borderColor = cell.imgProPic.backgroundColor.CGColor;
    }
    else if ([[viewControllerDictionary objectForKey:kSlideVCTitleKey] isEqualToString:@"keySlSearchProvider"]) {
        cell.lblArrow.hidden = true;
        cell.lblSearch.hidden = false;
        cell.lblTitle.textColor = [UIColor colorWithRed:90.0/255.0 green:167.0/255.0 blue:60.0/255.0 alpha:1.0];
    }
    else if ([[viewControllerDictionary objectForKey:kSlideVCTitleKey] isEqualToString:@"keySlMyAppointments"]) {
        cell.lblCount.hidden = false;
        cell.lblCount.text = [NSString stringWithFormat:@"%ld", (long)[Singleton sharedSingleton].intSlideMenuAppointmentCount];
        cell.lblCount.textColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
        
        if ([Singleton sharedSingleton].intSlideMenuAppointmentCount == 0) {
            cell.lblCount.hidden = true;
        }
    }
    else if ([[viewControllerDictionary objectForKey:kSlideVCTitleKey] isEqualToString:@"keySlInbox"]) {
        cell.lblCount.hidden = false;
        cell.lblCount.text = [NSString stringWithFormat:@"%@ %ld", LocalizedString(@"keySlNew", nil), (long)[Singleton sharedSingleton].intSlideMenuInboxCount];
        cell.lblCount.textColor = [UIColor colorWithRed:90.0/255.0 green:167.0/255.0 blue:60.0/255.0 alpha:1.0];
        
        if ([Singleton sharedSingleton].intSlideMenuInboxCount == 0) {
            cell.lblCount.hidden = true;
        }
    }
    else if ([[viewControllerDictionary objectForKey:kSlideVCTitleKey] isEqualToString:@"keySlMyReviews"]) {
        cell.lblCount.hidden = false;
        cell.lblCount.text = [NSString stringWithFormat:@"%ld", (long)[Singleton sharedSingleton].intSlideMenuReviewCount];
        cell.lblCount.textColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
        
        if ([Singleton sharedSingleton].intSlideMenuReviewCount == 0) {
            cell.lblCount.hidden = true;
        }
    }
    return cell;
}

    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *viewControllerDictionary = nil;
    
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 6) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isClickSlidMenu"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    } else  {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isClickSlidMenu"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"MPIsFavorit"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideVCSectionVCKey] objectAtIndex:indexPath.row];
    
    Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideVCClassKey];
    NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideVCNibNameKey];
    
    UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
    
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
    [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
    
    [self configureViewController:viewController];
    
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
        if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserRole"] isEqualToString:@"2"]) {
            if ([[viewControllerDictionary objectForKey:kSlideVCTitleKey] isEqualToString:@"keySlMyAppointments"]) {
                ProviderSchedulingVC *providerSchedulingObj = (ProviderSchedulingVC *) viewController;
                providerSchedulingObj.boolIsAppointmentSel = true;
            }
        }
    }
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    [self slideInSlideNavigationControllerView];
}
    
#pragma mark -
#pragma mark Button Click Method
    
-(IBAction) btnCloseMenuClick : (id)sender {
    [self menuBarButtonItemPressed:btnCloseMenu];
}
    
-(void) btnLogoutClick : (id) sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"" message: LocalizedString(@"keyLogoutMsg", nil) preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalizedString(@"keyYes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AppDelegate *appDel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDel logoutUserCall];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LocalizedString(@"keyNo", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}
    
#pragma mark -
#pragma mark UITextField Delegate Method
    
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSDictionary *viewControllerDictionary = nil;
    
    viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:1] objectForKey:kSlideVCSectionVCKey] objectAtIndex:1];
    
    Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideVCClassKey];
    NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideVCNibNameKey];
    UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
    
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
    [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
    
    [self configureViewController:viewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    [self slideInSlideNavigationControllerView];
    return YES;
}
    
- (void)viewDidUnload {
    [super viewDidUnload];
}
    

- (void)setGoToInboxNotificationController {
    
    NSDictionary *viewControllerDictionary = nil;
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
        if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserRole"] isEqualToString:@"1"]) { //patient
            viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:7];

        } else {
            viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:6];
        }
        Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideVCClassKey];
        NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideVCNibNameKey];
        
        UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
        
        if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
            [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
        
        [self configureViewController:viewController];
        
        if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
            if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserRole"] isEqualToString:@"2"]) {
                if ([[viewControllerDictionary objectForKey:kSlideVCTitleKey] isEqualToString:@"keySlMyAppointments"]) {
                    ProviderSchedulingVC *providerSchedulingObj = (ProviderSchedulingVC *) viewController;
                    providerSchedulingObj.boolIsAppointmentSel = true;
                }
            }
        }
        
        [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
        [self slideInSlideNavigationControllerView];
    }
    
}

- (void)setGoToSearchMapViewControllerController{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isClickSlidMenu"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSDictionary *viewControllerDictionary = nil;
    
    viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:0] objectForKey:kSlideVCSectionVCKey] objectAtIndex:3];
    
    Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideVCClassKey];
    NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideVCNibNameKey];
    
    UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
    
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
        [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
    
    [self configureViewController:viewController];
    
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
        if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserRole"] isEqualToString:@"2"]) {
            if ([[viewControllerDictionary objectForKey:kSlideVCTitleKey] isEqualToString:@"keySlMyAppointments"]) {
                ProviderSchedulingVC *providerSchedulingObj = (ProviderSchedulingVC *) viewController;
                providerSchedulingObj.boolIsAppointmentSel = true;
            }
        }
    }
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    [self slideInSlideNavigationControllerView];
}
@end
