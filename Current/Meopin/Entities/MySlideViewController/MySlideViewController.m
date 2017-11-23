//
//  MySlideViewController.m
//  SlideViewController
//
//  Created by Andrew Carter on 12/18/11.

#import "MySlideViewController.h"
#import "Meopin-Swift.h"

@implementation MySlideViewController

@synthesize datasource = _datasource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self addDynamicDataSource];
    }
    
    return self;
}

-(void) addDynamicDataSource {
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    NSMutableArray *arrSectDictionaries = [[NSMutableArray alloc] init];
    
    //section 1 * * * * * * * * * * * * * * * * * * * * * *
    NSMutableDictionary *sectionOne = [NSMutableDictionary dictionary];
    [sectionOne setObject:@"" forKey:kSlideVCTitle];
    
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
        if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserRole"] isEqualToString:@"1"]) { //patient
            NSString *strFullName = [NSString stringWithFormat:@"%@ %@", [Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserFName"], [Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserLName"]];
            NSMutableDictionary *vcDict1_1 = [NSMutableDictionary dictionary];
            [vcDict1_1 setObject:strFullName forKey:kSlideVCTitleKey];
            [vcDict1_1 setObject:@"PatientViewProfileVC" forKey:kSlideVCNibNameKey];
            [vcDict1_1 setObject:[PatientViewProfileVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_1];
            
            NSMutableDictionary *vcDict1_2 = [NSMutableDictionary dictionary];
            [vcDict1_2 setObject:@"keySlHome" forKey:kSlideVCTitleKey];
            [vcDict1_2 setObject:@"HomeVC" forKey:kSlideVCNibNameKey];
            [vcDict1_2 setObject:[HomeVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_2];
            
            NSMutableDictionary *vcDict1_3 = [NSMutableDictionary dictionary];
            [vcDict1_3 setObject:@"keySlDashboard" forKey:kSlideVCTitleKey];
            [vcDict1_3 setObject:@"PatientDashboardVC" forKey:kSlideVCNibNameKey];
            [vcDict1_3 setObject:[PatientDashboardVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_3];
            
            NSMutableDictionary *vcDict1_4 = [NSMutableDictionary dictionary];
            [vcDict1_4 setObject:@"keySlSearchProvider" forKey:kSlideVCTitleKey];
            [vcDict1_4 setObject:@"SearchProviderVC" forKey:kSlideVCNibNameKey];
            [vcDict1_4 setObject:[SearchProviderVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_4];
            
            NSMutableDictionary *vcDict1_5 = [NSMutableDictionary dictionary];
            [vcDict1_5 setObject:@"keySlMakeAppointment" forKey:kSlideVCTitleKey];
            [vcDict1_5 setObject:@"SearchProviderVC" forKey:kSlideVCNibNameKey];
            [vcDict1_5 setObject:[SearchProviderVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_5];
            
            NSMutableDictionary *vcDict1_6 = [NSMutableDictionary dictionary];
            [vcDict1_6 setObject:@"keySlMyAppointments" forKey:kSlideVCTitleKey];
            [vcDict1_6 setObject:@"PT_MyAppointmentsVC" forKey:kSlideVCNibNameKey];
            [vcDict1_6 setObject:[PT_MyAppointmentsVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_6];
            
            NSMutableDictionary *vcDict1_7 = [NSMutableDictionary dictionary];
            [vcDict1_7 setObject:@"keySlWriteReview" forKey:kSlideVCTitleKey];
            [vcDict1_7 setObject:@"SearchProviderVC" forKey:kSlideVCNibNameKey];
            [vcDict1_7 setObject:[SearchProviderVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_7];
            
            NSMutableDictionary *vcDict1_8 = [NSMutableDictionary dictionary];
            [vcDict1_8 setObject:@"keySlInbox" forKey:kSlideVCTitleKey];
            [vcDict1_8 setObject:@"PT_InboxVC" forKey:kSlideVCNibNameKey];
            [vcDict1_8 setObject:[PT_InboxVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_8];
            
            NSMutableDictionary *vcDict1_9 = [NSMutableDictionary dictionary];
            [vcDict1_9 setObject:@"keySlMyReviews" forKey:kSlideVCTitleKey];
            [vcDict1_9 setObject:@"PT_MyReviewsVC" forKey:kSlideVCNibNameKey];
            [vcDict1_9 setObject:[PT_MyReviewsVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_9];
            
            NSMutableDictionary *vcDict1_10 = [NSMutableDictionary dictionary];
            [vcDict1_10 setObject:@"keySlMyFavorites" forKey:kSlideVCTitleKey];
            [vcDict1_10 setObject:@"PT_MyFavoritesVC" forKey:kSlideVCNibNameKey];
            [vcDict1_10 setObject:[PT_MyFavoritesVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_10];
            
            NSMutableDictionary *vcDict1_11 = [NSMutableDictionary dictionary];
            [vcDict1_11 setObject:@"keySlHelpDesk" forKey:kSlideVCTitleKey];
            [vcDict1_11 setObject:@"PT_HelpDeskVC" forKey:kSlideVCNibNameKey];
            [vcDict1_11 setObject:[PT_HelpDeskVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_11];
        }
        else {//provider
            NSString *strFullName = [NSString stringWithFormat:@"%@ %@", [Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserFName"], [Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserLName"]];
            NSMutableDictionary *vcDict1_1 = [NSMutableDictionary dictionary];
            [vcDict1_1 setObject:strFullName forKey:kSlideVCTitleKey];
            [vcDict1_1 setObject:@"ProviderViewProfileVC" forKey:kSlideVCNibNameKey];
            [vcDict1_1 setObject:[ProviderViewProfileVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_1];
            
//            NSMutableDictionary *vcDict1_2 = [NSMutableDictionary dictionary];
//            [vcDict1_2 setObject:LocalizedString(@"keySlHome", nil) forKey:kSlideVCTitleKey];
//            [vcDict1_2 setObject:@"HomeVC" forKey:kSlideVCNibNameKey];
//            [vcDict1_2 setObject:[HomeVC class] forKey:kSlideVCClassKey];
//            [arrSectDictionaries addObject:vcDict1_2];
            
            NSMutableDictionary *vcDict1_3 = [NSMutableDictionary dictionary];
            [vcDict1_3 setObject:@"keySlDashboard" forKey:kSlideVCTitleKey];
            [vcDict1_3 setObject:@"ProviderDashboardVC" forKey:kSlideVCNibNameKey];
            [vcDict1_3 setObject:[ProviderDashboardVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_3];
            
            NSMutableDictionary *vcDict1_4 = [NSMutableDictionary dictionary];
            [vcDict1_4 setObject:@"keySlMyAppointments" forKey:kSlideVCTitleKey];
            [vcDict1_4 setObject:@"ProviderSchedulingVC" forKey:kSlideVCNibNameKey];
            [vcDict1_4 setObject:[ProviderSchedulingVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_4];
            
            NSMutableDictionary *vcDict1_5 = [NSMutableDictionary dictionary];
            [vcDict1_5 setObject:@"keySlAppointmentSettings" forKey:kSlideVCTitleKey];
            [vcDict1_5 setObject:@"ProviderSchedulingVC" forKey:kSlideVCNibNameKey];
            [vcDict1_5 setObject:[ProviderSchedulingVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_5];
            
            NSMutableDictionary *vcDict1_6 = [NSMutableDictionary dictionary];
            [vcDict1_6 setObject:@"keySlReadMedicalArticles" forKey:kSlideVCTitleKey];
            [vcDict1_6 setObject:@"PR_BlogsVC" forKey:kSlideVCNibNameKey];
            [vcDict1_6 setObject:[PR_BlogsVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_6];
            
            NSMutableDictionary *vcDict1_7 = [NSMutableDictionary dictionary];
            [vcDict1_7 setObject:@"keySlMyReviews" forKey:kSlideVCTitleKey];
            [vcDict1_7 setObject:@"PR_MyReviewsVC" forKey:kSlideVCNibNameKey];
            [vcDict1_7 setObject:[PR_MyReviewsVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_7];
            
            NSMutableDictionary *vcDict1_8 = [NSMutableDictionary dictionary];
            [vcDict1_8 setObject:@"keySlInbox" forKey:kSlideVCTitleKey];
            [vcDict1_8 setObject:@"PT_InboxVC" forKey:kSlideVCNibNameKey];
            [vcDict1_8 setObject:[PT_InboxVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_8];

//            NSMutableDictionary *vcDict1_9 = [NSMutableDictionary dictionary];
//            [vcDict1_9 setObject:@"keySlAccountSettings" forKey:kSlideVCTitleKey];
//            [vcDict1_9 setObject:@"ProviderProfile" forKey:kSlideVCNibNameKey];
//            [vcDict1_9 setObject:[ProviderProfile class] forKey:kSlideVCClassKey];
//            [arrSectDictionaries addObject:vc Dict1_9];
            
            NSMutableDictionary *vcDict1_10 = [NSMutableDictionary dictionary];
            [vcDict1_10 setObject:@"keySlHelpDesk" forKey:kSlideVCTitleKey];
            [vcDict1_10 setObject:@"PT_HelpDeskVC" forKey:kSlideVCNibNameKey];
            [vcDict1_10 setObject:[PT_HelpDeskVC class] forKey:kSlideVCClassKey];
            [arrSectDictionaries addObject:vcDict1_10];
        }
    }
    else {
        NSMutableDictionary *vcDict1_1 = [NSMutableDictionary dictionary];
        [vcDict1_1 setObject:@"keySlHome" forKey:kSlideVCTitleKey];
        [vcDict1_1 setObject:@"HomeVC" forKey:kSlideVCNibNameKey];
        [vcDict1_1 setObject:[HomeVC class] forKey:kSlideVCClassKey];
        [arrSectDictionaries addObject:vcDict1_1];
        
        NSMutableDictionary *vcDict1_2 = [NSMutableDictionary dictionary];
        [vcDict1_2 setObject:@"keySlSearchProvider" forKey:kSlideVCTitleKey];
        [vcDict1_2 setObject:@"SearchProviderVC" forKey:kSlideVCNibNameKey];
        [vcDict1_2 setObject:[SearchProviderVC class] forKey:kSlideVCClassKey];
        [arrSectDictionaries addObject:vcDict1_2];
    }
    [sectionOne setObject:arrSectDictionaries forKey:kSlideVCSectionVCKey];
    [datasource addObject:sectionOne];
    
    _datasource = datasource;
}

- (UIViewController *)initialViewController {
    if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserIsLoggedIn"] isEqualToString:@"1"]) {
        if ([[Singleton.sharedSingleton retriveFromUserDefaultsWithKey:@"meopinUserRole"] isEqualToString:@"1"]) { //patient
            HomeVC *homeObj = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
            return homeObj;
        }
        else {//provider
            ProviderDashboardVC *providerDashboardObj = [[ProviderDashboardVC alloc] initWithNibName:@"ProviderDashboardVC" bundle:nil];
            return providerDashboardObj;
        }
    }
    else {
        HomeVC *homeObj = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
        return homeObj;
    }
}

- (NSIndexPath *)initialSelectedIndexPath {
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)configureViewController:(UIViewController *)viewController userInfo:(id)userInfo {
    if ([viewController isKindOfClass:[HomeVC class]]) {
        NSDictionary *info = (NSDictionary *)userInfo;
        HomeVC *ViewController = (HomeVC *)viewController;
        ViewController.navigationItem.title = [info objectForKey:@"name"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
