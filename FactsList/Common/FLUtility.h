//
//  FLUtility.h
//  SampleList
//
//  Created by Santhosh on 22/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FLUtility : NSObject

+ (FLUtility*)sharedInstance;
-(NSInteger)getHeightForString:(NSString*)strDesc;
-(UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize;

@end
