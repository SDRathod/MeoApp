//
//  SlideViewCustomCell.h
//  UniversityCompare
//
//  Created by Topstech on 6/3/14.
//  Copyright (c) 2014 Topstech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideViewCustomCell : UITableViewCell {
    UILabel *lblTitle;
    UIImageView *imgProPic;
    UILabel *lblCount;
    UILabel *lblArrow;
    UILabel *lblSearch;
}

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIImageView *imgProPic;
@property (nonatomic, retain) IBOutlet UILabel *lblCount;
@property (nonatomic, retain) IBOutlet UILabel *lblArrow;
@property (nonatomic, retain) IBOutlet UILabel *lblSearch;

-(void) setLanguageTitles;

@end
