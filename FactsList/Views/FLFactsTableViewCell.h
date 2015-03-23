//
//  FLTableViewCell.h
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLFactsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelDescription;
@property(nonatomic,retain)UIImageView *imageViewTile;
@property(nonatomic,retain)UIView *viewBackground;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier ;
-(void)configureCell;

@end
