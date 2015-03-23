//
//  FLUtility.m
//  SampleList
//
//  Created by Santhosh on 22/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "FLUtility.h"
#import "FLConstants.h"
@implementation FLUtility

+ (FLUtility*)sharedInstance
{
    static FLUtility *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FLUtility alloc] init];
    });
    return _sharedInstance;
}

//gets the height of the Label based on the string
-(NSInteger)getHeightForString:(NSString*)strDesc
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGSize constrainedSize = CGSizeMake(screenSize.width-kImageTileWidth, FLT_MAX);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"HelveticaNeue" size:11.0], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strDesc attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGRect newFrame = CGRectMake(0, kTitleHeight, screenSize.width-kImageTileWidth - kTwentyOffset-kTenOffset, kImageTileWidth);
    
    if (requiredHeight.size.width > newFrame.size.width) {
        requiredHeight = CGRectMake(0,kTitleHeight, newFrame.size.width, requiredHeight.size.height);
    }
    return requiredHeight.size.height+kTitleHeight;
    
}

//resize the image for the given size
-(UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
