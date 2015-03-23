//
//  FLTableViewCell.m
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "FLFactsTableViewCell.h"
#import "FLDataDownloader.h"
#import "FLConstants.h"

@implementation FLFactsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // Initialization code
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGSize cellSize = self.frame.size;
        
        self.viewBackground = [[UIView alloc] init];
        [self.contentView addSubview:_viewBackground];        
        self.labelTitle = [[UILabel alloc] init];
        self.labelTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        self.labelTitle.textColor = [UIColor purpleColor];
        [self.contentView addSubview:_labelTitle];
        
        self.labelDescription = [[UILabel alloc] init];
        self.labelDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
        self.labelDescription.lineBreakMode = NSLineBreakByWordWrapping;
        self.labelDescription.numberOfLines = 0;
        [self.contentView addSubview:_labelDescription];
        
        self.imageViewTile = [[UIImageView alloc] initWithFrame:CGRectMake(cellSize.width - kImageTileWidth, kImageTileWidth, kImageTileHeight, kImageTileHeight)];
        _imageViewTile.contentMode = UIViewContentModeScaleToFill;
        
        [self.contentView addSubview:_imageViewTile];
    }
    return self;
    
    
}
-(void)configureCell
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = screenSize.width;
    
    self.labelTitle.frame = CGRectMake(kTenOffset, 0, kTitleWidth, kTitleHeight);
    self.labelDescription.frame = CGRectMake(kTenOffset, kTitleHeight, screenWidth-kImageTileWidth - kTwentyOffset-kTenOffset, kTitleHeight);
    self.imageViewTile.frame = CGRectMake(screenWidth-kImageTileWidth - kTenOffset, kTitleHeight, kImageTileWidth, kImageTileHeight);
    self.viewBackground.frame = CGRectMake(0, 0, screenWidth, kTitleHeight);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
    }
    return self;
}
@end
