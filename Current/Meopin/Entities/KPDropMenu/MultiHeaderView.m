//
//  MultiHeaderView.m
//  Meopin
//
//  Created by Tops on 9/26/17.
//  Copyright © 2017 Tops. All rights reserved.
//

#import "MultiHeaderView.h"
#import "LocalizeHelper.h"

@interface MultiHeaderView ()

@end

@implementation MultiHeaderView

@synthesize btnCancel, btnDone, lblTitle;

-(void) refreshLanguageTitle {
    [btnCancel setTitle:LocalizedString(@"keyCancel", nil) forState:UIControlStateNormal];
    [btnDone setTitle:LocalizedString(@"keyDone", nil) forState:UIControlStateNormal];
    lblTitle.text = LocalizedString(@"KeyFilterSelect", nil);
}

@end
