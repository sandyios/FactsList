//
//  FLFactsModel.h
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//
/*
 FLFactsModel
    -FLFactsRowModel {1..n}
        (title,imageDescription,imageURL)
 
 */
#import <Foundation/Foundation.h>
#import "FLFactsRowModel.h"

//Downloader delegate to notify the controller on the data download status from the model
@protocol DataDownloaderDelegate <NSObject>

-(void)didFinishDataDownload:(NSData*)responseData;
-(void)didFailDataDownloadWithError:(NSError*)error;

@end

@interface FLFactsModel : NSObject

@property(nonatomic,copy)   NSString *title;
@property(nonatomic,strong) NSMutableArray *arrayRowsModel;
@property(nonatomic,strong) NSURLRequest *urlRequest;
@property(nonatomic,strong) NSMutableDictionary *dictImageCache;
@property(nonatomic,assign) id <DataDownloaderDelegate> downloaderDelegate;

- (id)initWithRequest:(NSURLRequest*)urlRequest andDelegate:(id)delagate;
-(void)startFactsRequest;

@end
