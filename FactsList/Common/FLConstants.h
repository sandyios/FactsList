//
//  FLConstants.h
//  SampleList
//
//  Created by Santhosh on 20/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#ifndef FactsList_FLConstants_h
#define FactsList_FLConstants_h

//num constants
#define kImageTileWidth 80
#define kImageTileHeight 80
#define kTitleWidth 200
#define kTitleHeight 20
#define kTwentyOffset 20
#define kTenOffset 10
#define kActivityIndicatorWidth 50
#define kActivityIndicatorHeight 50

//URLS
#define kFeedURL @"https://dl.dropboxusercontent.com/u/746330/facts.json"

//error msgs
#define kErrorMsgNoFeedData @"No data found in the feed.Please try again later"
#define kErrorMsgProblemInLoading @"Problem in loading the feed.Please try again later"

//facts json keys
#define kTitleKey @"title"
#define kRowsKey @"rows"
#define kDescriptionKey @"description"
#define kImageHrefKey @"imageHref"

#endif
