//
//  FLFactsTableViewController.m
//  SampleList
//
//  Created by Santhosh on 19/03/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "FLFactsTableViewController.h"
#import "FLFactsTableViewCell.h"
#import "FLDataDownloader.h"
#import "FLFactsModel.h"
#import "FLDataParser.h"
#import "AppDelegate.h"
#import "FLUtility.h"

@interface FLFactsTableViewController ()<DataDownloaderDelegate>

@property(nonatomic,strong)FLFactsModel *factsModel;
@property(nonatomic,strong)FLDataDownloader *downloader;
@property(nonatomic,strong)FLUtility *utility;
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicatorRefresh;

@end

@implementation FLFactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //downloader object and utility object initialization
    self.downloader = [FLDataDownloader sharedInstance];
    self.utility = [FLUtility sharedInstance];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked:)];
    
    //setting up activity indicator
    self.activityIndicatorRefresh =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self adjustActivityIndiactor];
    [self.tableView addSubview: _activityIndicatorRefresh];
    [self.activityIndicatorRefresh setBackgroundColor:[UIColor blackColor]];
    self.activityIndicatorRefresh.alpha = 0.8;
    [self.activityIndicatorRefresh.layer setCornerRadius:3.0f];
    self.tableView.allowsSelection = NO;
    
    //forming the feed request and asking the model to download the data and notify on finish
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:kFeedURL]];
    _factsModel = [[FLFactsModel alloc] initWithRequest:theRequest andDelegate:self];

    //download Fatcs data From Model and notify after completion to controller to update view
    [self downloadFactsDataFromModel];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    //refreshing the table
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_factsModel.arrayRowsModel count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateHeightForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    FLFactsTableViewCell *cell = (FLFactsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FLFactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //configure cell subview UI by setting up the frames
    [cell configureCell];
    cell.tag = indexPath.row;
    
    //setting up the gradient for cell background property of custom Tableviewcell-FLFactsTableViewCell
    [self setGradientForCellBackground:cell.viewBackground forIndexPath:indexPath];
    
    //loading the title,description and image of each row from FLFactsRowModel
    FLFactsRowModel *rowsModel =[_factsModel.arrayRowsModel objectAtIndex:indexPath.row];
    if (![rowsModel.title isEqual:[NSNull null]]) {
        cell.labelTitle.text = rowsModel.title;
    }
    else
        cell.labelTitle.text = @"";
    
    if (![rowsModel.imageDescription isEqual:[NSNull null]]) {
        cell.labelDescription.text = rowsModel.imageDescription;
        [self setUpdatedFrameForDescriptionLabel:cell.labelDescription];
    }
    else
        cell.labelDescription.text = @"";
    
    
    UIImage *imageNotAvailable = [UIImage imageNamed:@"image_not_available"];
    cell.imageViewTile.image = [UIImage imageNamed:@"broken-image"];
    
    if (![rowsModel.imageURL isEqual:[NSNull null]]) {
        //if cached image is found loading the same otherwise initializing download of the image
        UIImage *imageCached = [_factsModel.dictImageCache valueForKey:rowsModel.imageURL];
        if (imageCached) {
            cell.imageViewTile.image = imageCached;
        }
        else if (rowsModel.imageURL != nil && [rowsModel.imageURL length]>0) {
            NSURL *url = [NSURL URLWithString:rowsModel.imageURL];
            //downloading the image from the given URL and loading it in the cell's imageview and caching it in the model for future use
            [_downloader downloadImageAtURL:url completionHandler:^(NSData *data) {
                if ([data length] && data != nil )
                {
                    if (cell.tag == indexPath.row)
                    {
                        cell.imageViewTile.image = [UIImage imageWithData:data];
                        [cell setNeedsLayout];
                        [_factsModel.dictImageCache setValue:[UIImage imageWithData:data] forKey:rowsModel.imageURL];
                    }
                }
            }];
        }
        else
            cell.imageViewTile.image = imageNotAvailable;
    }
    else
        cell.imageViewTile.image = imageNotAvailable;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustActivityIndiactor];
}
#pragma mark - Downloader Methods

//downloads the facts feed data
-(void)downloadFactsDataFromModel
{
    //starting activity indicator
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.activityIndicatorRefresh startAnimating];
                       [self.activityIndicatorRefresh setHidden:NO];
                   });
    
    //creating the FactsModel object to download the feed and notify on completion
    [_factsModel startFactsRequest];
    
}

#pragma mark - Data Downloader Completion Delegates From FactsModel

-(void)didFinishDataDownload:(NSData*)responseData
{
    //removing the image cache to make sure images are downloaded again
    [_factsModel.dictImageCache removeAllObjects];
    
    //parse the converted data and assign to the Facts model
    FLDataParser *dataParser = [FLDataParser new];
    [dataParser parseJsonData:responseData andSetModel:_factsModel];
    
    if ([_factsModel.arrayRowsModel count]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:kErrorMsgNoFeedData delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    //after refreshing the model refreshing the UI
    self.navigationItem.title =_factsModel.title;
    [self.tableView reloadData];
    
    //stop activity
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.activityIndicatorRefresh stopAnimating];
                       [self.activityIndicatorRefresh setHidden:YES];
                       
                   });
    
}

-(void)didFailDataDownloadWithError:(NSError*)error
{
    
    //Showing error alertview
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:kErrorMsgProblemInLoading delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    //stop activity indicator
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.activityIndicatorRefresh stopAnimating];
                       [self.activityIndicatorRefresh setHidden:YES];
                       
                   });
}


#pragma mark - Helper

//setting the gradient  accoring to the indexpath height
-(void)setGradientForCellBackground:(UIView*)viewBg forIndexPath:(NSIndexPath*)indexPath
{

    //getting the height for the particular cell and loading the gradient accordingly
    NSInteger nHeightForViewBg = [self calculateHeightForIndexPath:indexPath];
    CGRect newFrame = viewBg.frame;
    newFrame.size.height = nHeightForViewBg;
    viewBg.frame = newFrame;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = viewBg.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    //clearing the gradient if alreday present
    if ([viewBg.layer.sublayers count]) {
        [[viewBg.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
    }
    [viewBg.layer insertSublayer:gradient atIndex:0];

}

//setting the description label frame/height dynamically based on the text from description

-(CGRect)setUpdatedFrameForDescriptionLabel:(UILabel*)lblDesc
{
    CGRect newFrame = lblDesc.frame;
    
    [_utility getHeightForString:lblDesc.text ];
    newFrame.size.height = [_utility getHeightForString:lblDesc.text ];
    lblDesc.frame = newFrame;
    return newFrame;
}

//calculates the row height based on the cell content's height
-(NSInteger)calculateHeightForIndexPath:(NSIndexPath*)nIndexPath
{
    NSInteger nHeight = kTitleHeight;//tilte

    if ([_factsModel.arrayRowsModel count]>0) {
        FLFactsRowModel *rowsModel =[_factsModel.arrayRowsModel objectAtIndex:nIndexPath.row];
        
        if (![rowsModel.imageDescription isEqual:[NSNull null]]) {
            NSInteger nDescHeight = [_utility getHeightForString:rowsModel.imageDescription ];
            if (nDescHeight >100) {
                nHeight += [_utility getHeightForString:rowsModel.imageDescription ];
                
            }
            else
                nHeight += kImageTileHeight;
        }
        else
            nHeight += kImageTileHeight;

    }
    return nHeight +kTenOffset;
    
}

//to adjust the activity indicator to Tableview center
-(void)adjustActivityIndiactor
{
    
    CGPoint centrePoint = self.view.center;
    centrePoint.y += self.tableView.contentOffset.y;
    self.activityIndicatorRefresh.frame = CGRectMake(centrePoint.x- (kActivityIndicatorWidth/2), centrePoint.y - (kActivityIndicatorHeight/2) + kTwentyOffset, kActivityIndicatorWidth, kActivityIndicatorHeight);

}

#pragma mark - IBActions

//refresh action
-(IBAction)refreshClicked:(id)sender
{
    [self adjustActivityIndiactor];
    [self downloadFactsDataFromModel];
}
@end
