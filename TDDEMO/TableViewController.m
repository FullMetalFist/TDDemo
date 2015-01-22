//
//  TableViewController.m
//  TDDEMO
//
//  Created by Michael Vilabrera on 1/16/15.
//  Copyright (c) 2015 Giving Tree. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "ViewController.h"

NSString *const Twitter_API_Key = @"F8XvTE04I5caENvlejC7Blpp6";
NSString *const Twitter_API_Secret = @"x6055t5T6fKafK37aI4akQmkRDvmWH0KW9bhE8cf2gbyR1xr9R";
NSString *const Callback = @"http://fullmetalfist.github.io/";

static NSString *const TweetTableReuseIdentifier = @"TwitterCell";

@interface TableViewController () <TWTRTweetViewDelegate>

@property (strong, nonatomic) NSArray *tweets;

@property (strong, nonatomic) TWTRTweetTableViewCell *tableViewCell;

@property (assign, nonatomic) CATransform3D initialTransformation;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
//    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
    [self.navigationController removeFromParentViewController];
    
    NSArray *tweetIDs = @[@"293034645"];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
    
    self.tableViewCell = [[TWTRTweetTableViewCell alloc] init];
    
    // are tweets loading here??
    __weak typeof(self) weakSelf = self;
    [[[Twitter sharedInstance] APIClient]
     loadTweetsWithIDs:tweetIDs
     completion:^(NSArray *tweets, NSError *error) {
         if (tweets) {
             typeof(self) strongSelf = weakSelf;
             strongSelf.tweets = tweets;
             [strongSelf.tableView reloadData];
         } else {
             NSLog(@"Failed to load tweet: %@",
                   [error localizedDescription]);
         }
     }];
    
    [self rotatingViews];
}

- (void) rotatingViews
{
    CGFloat rotationAngleDegrees = -45.0;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformation = transform;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.tweets count];
}


- (TWTRTweetTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TWTRTweet *tweet = self.tweets[indexPath.row];
    
    TWTRTweetTableViewCell *cell = (TWTRTweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TweetTableReuseIdentifier forIndexPath:indexPath];
    // Configure the cell...
    [cell configureWithTweet:tweet];
    cell.tweetView.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTRTweet *tweet = self.tweets[indexPath.row];
    [self.tableViewCell configureWithTweet:tweet];
    
    return [self.tableViewCell calculatedHeightForWidth:CGRectGetWidth(self.view.bounds)];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *tweet = (TableViewCell *)cell;
    
    tweet.layer.transform = self.initialTransformation;
    tweet.layer.opacity = 0.8;
    
    [UIView animateWithDuration:4 animations:^{
        tweet.layer.transform = CATransform3DIdentity;
        tweet.layer.opacity = 0.8;
    }];
}

#pragma mark -- TWTRTweetTableViewDelegate Methods

- (UIViewController *)viewControllerForPresentation {
    return self;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
