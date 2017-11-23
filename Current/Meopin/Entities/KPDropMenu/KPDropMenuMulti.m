//
//  KPDropMenu.m
//  KPDropMenu
//
//  Created by Krishna Patel on 22/03/17.
//  Copyright © 2017 Krishna. All rights reserved.
//

#import "KPDropMenuMulti.h"
#import "MultiHeaderView.h"

@interface KPDropMenuMulti () <UITableViewDelegate, UITableViewDataSource> {
    UIFont *selectedFont, *font, *itemFont;
    BOOL isCollapsed;
    UITapGestureRecognizer *tapGestureBackground;
    UILabel *label;
    NSMutableArray *arrTemp;
    NSMutableArray *arrTempSpeciality;

}

@end

@implementation KPDropMenuMulti
@synthesize SelectedIndex, tblView;
    
- (instancetype)init {
    if (self = [super init])
        [self initLayer];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self initLayer];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self initLayer];
    return self;
}

- (void)initLayer {
    SelectedIndex = -1;
    isCollapsed = TRUE;
    _itemTextAlignment = _titleTextAlignment = NSTextAlignmentCenter;
    _titleColor = [UIColor blackColor];
    _titleFontSize = 14.0;
    _itemHeight = 40.0;
   // self.backgroundColor = [UIColor redColor];
    _itemBackground = [UIColor whiteColor];
    _itemTextColor = [UIColor blackColor];
    _itemFontSize = 14.0;
    _itemsFont = [UIFont systemFontOfSize:14.0];
    _DirectionDown = YES;
    
}

#pragma mark - Setter

-(void)setTitle:(NSString *)title{
    _title = title;
}

-(void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment{
    if(titleTextAlignment)
        _titleTextAlignment = titleTextAlignment;
}

-(void)setItemTextAlignment:(NSTextAlignment)itemTextAlignment{
    if(itemTextAlignment)
        _itemTextAlignment = itemTextAlignment;
}

-(void)setTitleColor:(UIColor *)titleColor{
    if(titleColor)
        _titleColor = titleColor;
}

-(void)setTitleFontSize:(CGFloat)titleFontSize{
    if(titleFontSize)
        _titleFontSize = titleFontSize;
    
}

-(void)setItemHeight:(double)itemHeight{
    if(itemHeight)
        _itemHeight = itemHeight;
}

-(void)setItemBackground:(UIColor *)itemBackground{
    if(itemBackground)
        _itemBackground = itemBackground;
}

-(void)setItemTextColor:(UIColor *)itemTextColor{
    if(itemTextColor)
        _itemTextColor = itemTextColor;
}

-(void)setItemFontSize:(CGFloat)itemFontSize{
    if(itemFontSize)
        _itemFontSize = itemFontSize;
}

-(void)setItemsFont:(UIFont *)itemFont1{
    if(itemFont1)
        _itemsFont = itemFont1;
}

-(void)setDirectionDown:(BOOL)DirectionDown{
    _DirectionDown = DirectionDown;
}

#pragma mark - Setups

-(void)SetupCategoriRecords {
    arrTemp = [NSMutableArray array];
    arrTempSpeciality = [NSMutableArray array];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([_strSelectionType  isEqual: @"Category"]) {
        arrTemp = [[userDefaults objectForKey:@"MPCategory"] mutableCopy];
    } else {
        arrTempSpeciality = [[userDefaults objectForKey:@"MPSpecialty"] mutableCopy];
    }
    [self.tblView reloadData];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.borderWidth = 0;
    
    if(label == nil){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        label.textColor = _titleColor;
        label.text = _title;
        label.textAlignment = _titleTextAlignment;
        label.font = font;
        label.hidden = true;
        [self addSubview:label];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tapGesture];
    
    tblView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)] ;
    [tblView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tblView.delegate = self;
    tblView.dataSource = self;
    tblView.backgroundColor = _itemBackground;
}

-(void)didTap : (UIGestureRecognizer *)gesture {
    isCollapsed = !isCollapsed;
    if(!isCollapsed) {
        CGFloat height = (CGFloat)(_items.count > 5 ? _itemHeight*5 : _itemHeight * (double)(_items.count));
        
        tblView.layer.zPosition = 1;
        [tblView removeFromSuperview];
//        tblView.backgroundColor = [UIColor colorWithRed: 42.0/255.0 green: 82.0/255.0 blue: 134/255.0 alpha:1.0];
        tblView.layer.borderColor = [[UIColor whiteColor] CGColor];
        tblView.layer.borderWidth = 0.5;
        tblView.layer.cornerRadius = 4;
        [self.superview addSubview:tblView];
        [tblView reloadData];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            if(_DirectionDown)
                tblView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height+5, self.frame.size.width, height);
            else
                tblView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 5 - height, self.frame.size.width, height);
        }];
        
        if(_delegate != nil){
            if([_delegate respondsToSelector:@selector(didShow:)])
                [_delegate didShow:self];
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2000, 2000)];
        view.tag = 99121;
        [self.superview insertSubview:view belowSubview:tblView];

            
        tapGestureBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)];
        [view addGestureRecognizer:tapGestureBackground];
        
    }
    else{
        [self collapseTableView];
    }
}

-(void)didTapBackground : (UIGestureRecognizer *)gesture {
//    if (_arrIndexItems.count > 0) {
//        [_arrIndexItems removeAllObjects];
//    }
//    isCollapsed = TRUE;
//    [self collapseTableView];
}

-(void)collapseTableView{
    if(isCollapsed){
        [UIView animateWithDuration:0.25 animations:^{
            
            if(_DirectionDown)
                tblView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height+5, self.frame.size.width, 0);
            else
                tblView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
        }];
        
        [[self.superview viewWithTag:99121] removeFromSuperview];
        if(_delegate != nil){
            if([_delegate respondsToSelector:@selector(didHide:)])
                [_delegate didHide:self];
        }
    }
}


- (void)btnDoneSelectClick {
    isCollapsed = TRUE;
    [self collapseTableView];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([_strSelectionType  isEqual: @"Category"]) {
        if(_delegate != nil){
            [userDefaults setObject:arrTemp forKey:@"MPCategory"];
            if([_delegate respondsToSelector:@selector(didSelectItem:arrSelectedIndex:)])
                [_delegate didSelectItem:self arrSelectedIndex:arrTemp];
        }
    } else {
        [userDefaults setObject:arrTempSpeciality forKey:@"MPSpecialty"];
        if(_delegate != nil){
            if([_delegate respondsToSelector:@selector(didSelectItem:arrSelectedIndex:)])
                [_delegate didSelectItem:self arrSelectedIndex:arrTempSpeciality];
        }
    }
}

 
- (void)btnCancelClick{

    if(_delegate != nil){
        if([_delegate respondsToSelector:@selector(didCancelTapDelegateMethod)])
        [_delegate didCancelTapDelegateMethod];
    }    
    isCollapsed = TRUE;
    [self collapseTableView];
}

#pragma mark - UITableView's Delegate and Datasource Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MultiHeaderView *headerView;
    if (headerView == nil ) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:@"MultiHeaderView" owner:self options:nil] firstObject];
        [headerView refreshLanguageTitle];
        
        [headerView.btnDone addTarget:self action:@selector(btnDoneSelectClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
        return  headerView;
    } else  {
        [headerView refreshLanguageTitle];
        
        [headerView.btnDone addTarget:self action:@selector(btnDoneSelectClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
        headerView.lblTitle.textColor = [UIColor whiteColor];
        return  headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = _itemTextAlignment;
    cell.textLabel.text = _items[indexPath.row];
    
    cell.textLabel.font = _itemsFont;
    cell.textLabel.textColor = _itemTextColor;
    NSLog(@"%@",[NSNumber numberWithInt:(int)indexPath.row]);
    
    if ([_strSelectionType  isEqual: @"Category"]) {
        
        if ([arrTemp containsObject:[NSNumber numberWithInt:(int)indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else  {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        if ([arrTempSpeciality containsObject:[NSNumber numberWithInt:(int)indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else  {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cell.backgroundColor = _itemBackground;
    cell.tintColor = [UIColor whiteColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _itemHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectedIndex = (int)indexPath.row;
    label.text = _items[SelectedIndex];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([_strSelectionType  isEqual: @"Category"]) {
        if ([arrTemp containsObject:[NSNumber numberWithInt:SelectedIndex]]) {
            [arrTemp removeObject:[NSNumber numberWithInt:SelectedIndex]];
        }
        else {
            [arrTemp addObject:[NSNumber numberWithInt:SelectedIndex]];
        }
    } else  {
        
        if ([arrTempSpeciality containsObject:[NSNumber numberWithInt:SelectedIndex]]) {
            [arrTempSpeciality removeObject:[NSNumber numberWithInt:SelectedIndex]];
            [userDefaults setObject:arrTempSpeciality forKey:@"MPSpecialty"];
        }
        else {
            [arrTempSpeciality addObject:[NSNumber numberWithInt:SelectedIndex]];
            [userDefaults setObject:arrTempSpeciality forKey:@"MPSpecialty"];
        }
    }
    
    [userDefaults synchronize];
    [self.tblView reloadData];
   
}
    
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
        
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
    
    
    
@end
