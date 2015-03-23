//
//  FLImageDownloader.h
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^DidCompleteDataDownload)(NSData *data);

@interface FLDataDownloader : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData * container;
}


@property (nonatomic,strong)NSURLConnection * internalConnection;
@property (nonatomic,copy)NSURLRequest *request;
@property (nonatomic,copy)void (^completitionBlock) (NSData *responseData, NSError * err);

+ (FLDataDownloader*)sharedInstance;
-(void)startDownload:(NSURLRequest *)req;
- (void)downloadImageAtURL:(NSURL*)url completionHandler:(DidCompleteDataDownload)complete;

@end
