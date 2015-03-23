//
//  FLDataParser.h
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLFactsModel.h"
@interface FLDataParser : NSObject

-(void)parseJsonData:(NSData*)jsonData andSetModel:(FLFactsModel*)factsModel;

@end
