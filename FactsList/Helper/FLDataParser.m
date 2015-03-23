//
//  FLDataParser.m
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "FLDataParser.h"
#import "FLConstants.h"

@implementation FLDataParser

-(void)parseJsonData:(NSData*)jsonData andSetModel:(FLFactsModel*)factsModel
{
    NSDictionary *dictJson = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    factsModel.title = [dictJson valueForKey:kTitleKey];
    [(NSMutableArray*)factsModel.arrayRowsModel removeAllObjects];
    NSArray *arrRowsData = [dictJson valueForKey:kRowsKey];
    [arrRowsData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dictRowData = obj;
        NSString *strTitle = [dictRowData valueForKey:kTitleKey];
        NSString *strDesc = [dictRowData valueForKey:kDescriptionKey];
        NSString *strImageURL = [dictRowData valueForKey:kImageHrefKey];
        
        if (![strTitle isEqual:[NSNull null]] || ![strDesc isEqual:[NSNull null]] || ![strImageURL isEqual:[NSNull null]]) {
            FLFactsRowModel *rowsModel = [FLFactsRowModel new];
            rowsModel.title =strTitle;
            rowsModel.imageDescription =strDesc;
            rowsModel.imageURL =strImageURL;
            [(NSMutableArray*)factsModel.arrayRowsModel addObject:rowsModel];

        }
    }];

}
@end
