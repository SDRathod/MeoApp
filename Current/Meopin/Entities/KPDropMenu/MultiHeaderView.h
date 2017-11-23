//
//  MultiHeaderView.h
//  Meopin
//
//  Created by Tops on 9/26/17.
//  Copyright © 2017 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

-(void) refreshLanguageTitle;

@end
