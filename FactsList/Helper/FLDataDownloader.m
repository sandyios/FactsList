//
//  FLImageDownloader.m
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "FLDataDownloader.h"

@implementation FLDataDownloader

+ (FLDataDownloader*)sharedInstance
{
    static FLDataDownloader *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FLDataDownloader alloc] init];
    });
    return _sharedInstance;
}

- (void)downloadImageAtURL:(NSURL*)url completionHandler:(DidCompleteDataDownload)complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(data);
        });
    });
}

-(void)startDownload:(NSURLRequest *)req {
    
    [self setRequest:req];
    if(_internalConnection!= nil)
    {
        [_internalConnection cancel];
    }
    container = [[NSMutableData alloc]init];
    
    _internalConnection = [[NSURLConnection alloc]initWithRequest:[self request] delegate:self startImmediately:YES];
    
}


#pragma mark NSURLConnectionDelegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [container appendData:data];
    
}

//If finish, return the data and the error nil
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self completitionBlock])
    {
        [self completitionBlock](container,nil);

    }
    
}

//If fail, return nil and an error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if([self completitionBlock])
        [self completitionBlock](nil,error);
        
}

@end
