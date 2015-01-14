//
//  PPRFavoritesTableViewController.m
//  Pepper966
//
//  Created by Akis on 1/14/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import "PPRFavoritesTableViewController.h"
#import "PPRFavoritesViewCell.h"
#import "FavoritesStore.h"

@interface PPRFavoritesTableViewController ()

@end

@implementation PPRFavoritesTableViewController
NSUInteger favoritesCounter;
UIImageView *backImgView;
UIView *redView;

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self loadData];
    favoritesCounter = [[[FavoritesStore sharedStore]allItems]count];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:118.0f/255.0f green:117.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)refreshView:(UIRefreshControl*)refresh {
    
   [self loadData];  //actually RE-loads data
    [self.tableView reloadData];
    if (self.refreshControl) {
        
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing tracklist..."];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                                 [formatter stringFromDate:[NSDate date]]];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
        [refresh endRefreshing];
    }
}

- (void)loadData {

    if ([[[FavoritesStore sharedStore]allItems]count]) {
        NSLog(@" inside load data:: %d",[[[FavoritesStore sharedStore]allItems]count]);
        favoritesCounter = [[[FavoritesStore sharedStore]allItems]count];
        [self.tableView reloadData];
    }
    else NSLog(@"VAGGELIS");
}

- (void)prepareView {
    
    NSDictionary *viewsDictinary = @{@"backView":backImgView, @"redView":redView};
    NSDictionary *metrics = @{@"vSpacingR":@-20, @"vSpacingL":@280, @"hSpacingR":@-20, @"hSpacingL":@180};
    
    NSArray *constrain_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vSpacingR-[redView]-vSpacingL-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:viewsDictinary];
    NSArray *constrain_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hSpacingL-[redView]-hSpacingR-|"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:viewsDictinary];
    [self.view addConstraints:constrain_POS_V];
    [self.view addConstraints:constrain_POS_H];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (favoritesCounter) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"count items::: %ld",(long)[[[FavoritesStore sharedStore]allItems]count]);
    return [[[FavoritesStore sharedStore]allItems]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PPRFavoritesViewCell";
    PPRFavoritesViewCell *cell = (PPRFavoritesViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPRFavoritesViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSArray *items = [[FavoritesStore sharedStore]allItems];
    Favorites *item = items[indexPath.row];
    
    cell.artist.text = item.artist;
    cell.track.text = item.track;
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:item.dateCreated
                                                       dateStyle:NSDateFormatterShortStyle
                                                       timeStyle:NSDateFormatterFullStyle];
    cell.dateCreated.text = dateStr;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
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
