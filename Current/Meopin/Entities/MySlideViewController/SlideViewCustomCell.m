//
//  SlideViewCustomCell.m
//  UniversityCompare
//
//  Created by Topstech on 6/3/14.
//  Copyright (c) 2014 Topstech. All rights reserved.
//

#import "SlideViewCustomCell.h"

@implementation SlideViewCustomCell

@synthesize lblTitle, imgProPic, lblCount, lblArrow, lblSearch;

-(void) setLanguageTitles {
    [self setDeviceSpecificFonts];
}

-(void) setDeviceSpecificFonts {
    lblTitle.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:(([UIScreen mainScreen].bounds.size.width * 11) / 320)];
    lblCount.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:(([UIScreen mainScreen].bounds.size.width * 9) / 320)];
    lblArrow.font = [UIFont fontWithName:@"Meopin_TOPS" size:(([UIScreen mainScreen].bounds.size.width * 7) / 320)];
    lblSearch.font = [UIFont fontWithName:@"Meopin_TOPS" size:(([UIScreen mainScreen].bounds.size.width * 13) / 320)];
}


@end
