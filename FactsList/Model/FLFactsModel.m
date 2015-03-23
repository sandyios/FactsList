//
//  FLFactsModel.h
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "FLFactsModel.h"
#import "FLDataDownloader.h"
@interface FLFactsModel()
@property(nonatomic,strong)FLDataDownloader *downloader;
@end

@implementation FLFactsModel
- (id)initWithRequest:(NSURLRequest*)urlRequest andDelegate:(id)delagate
{
    if ((self = [super init])) {
        self.arrayRowsModel = [[NSMutableArray alloc] init];
        self.downloaderDelegate = delagate;
        self.urlRequest = urlRequest;
        self.downloader = [FLDataDownloader sharedInstance];
        self.dictImageCache = [NSMutableDictionary new];

    }
    return self;
}

-(void)startFactsRequest
{
    [self downloadSampleListData];
}

#pragma mark - Helper

//downloads the feed and parse it to the model
-(void)downloadSampleListData
{
    __unsafe_unretained typeof(self) weakRefSelf = self;
    
    //download completion block
    [_downloader setCompletitionBlock:^(NSData *responseData, NSError *err) {
        
        if (!err) {
            
            //conversion of encoding
            NSString *str = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            //notifying the controller on success
            if ([weakRefSelf.downloaderDelegate respondsToSelector:@selector(didFinishDataDownload:)]) {
                [weakRefSelf.downloaderDelegate didFinishDataDownload:data];
            }
        }
        else {
            //notifying the controller on data failure
            if ([weakRefSelf.downloaderDelegate respondsToSelector:@selector(didFailDataDownloadWithError:)]) {
                [weakRefSelf.downloaderDelegate didFailDataDownloadWithError:nil];
            }

        }
        
    }];
    //start download
    [_downloader startDownload:self.urlRequest];
    
}

@end
