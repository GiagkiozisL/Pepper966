//
//  PPRTracklistTableViewController.m
//  Pepper966
//
//  Created by Akis on 1/8/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import "PPRTracklistTableViewController.h"
#import "PPRTrackViewCell.h"
#import "PPRTracklistParser.h"

@interface PPRTracklistTableViewController ()

@end

@implementation PPRTracklistTableViewController
NSInteger trackCounter;
NSDictionary *tempDict;
PPRTrackViewCell *cell;
NSArray *tempArtist;
NSArray *tempTitle;
NSArray *reversedArtistArray;
NSArray *reversedTitleArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:118.0f/255.0f green:117.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshView:(UIRefreshControl*)refresh {
    
    [self loadData];  //actually RE-loads data
    
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
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [PPRTracklistParser showTrackList:dict success:^(id jsonObject) {
        trackCounter = [jsonObject count];
        tempDict = jsonObject;
        for (NSDictionary *dictie in tempDict)
        {
            tempArtist = [tempDict valueForKey:@"artist"];
            tempTitle = [tempDict valueForKey:@"track"];
            
        }
        reversedArtistArray = [[tempArtist reverseObjectEnumerator] allObjects];
        reversedTitleArray = [[tempTitle reverseObjectEnumerator] allObjects];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (tempDict) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    
    return trackCounter;
} 


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"TrackViewCell";
    cell = (PPRTrackViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PPRTrackViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    };
    
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"like.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"message.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"facebook.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:0.7]
                                                icon:[UIImage imageNamed:@"twitter.png"]];
    
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                                title:@"More"];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                title:@"Delete"];
    
    cell.leftUtilityButtons = leftUtilityButtons;
//    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    
    cell.trackArtist.text = [reversedArtistArray objectAtIndex:indexPath.row];
    cell.trackTitle.text = [reversedTitleArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(PPRSwipeTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
   
    switch (index) {
        case 0:
        {
          UIAlertView *likedAlert = [[UIAlertView alloc]initWithTitle:@"Core Data reminder!"
        message:@"must add song to favorites!"
        delegate:self
        cancelButtonTitle:@"OK"
        otherButtonTitles: nil];
            [likedAlert show];
           
            break;
        }
            case 1:
        {
            UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Message reminder"
                                                                  message:@"Compose message to a friend!"
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK" otherButtonTitles:
                                                                                                    nil];
            [messageAlert show];
            break;
        }
            case 2:
        {
            UIAlertView *fbAlert = [[UIAlertView alloc ]initWithTitle:@"Fb!!"
        message:@"post it to fb!"
        delegate:self
        cancelButtonTitle:@"OK OK"
                                                    otherButtonTitles: nil];
            [fbAlert show];
            break;
        }
            case 3:
        {
            UIAlertView *twitterAlert = [[UIAlertView alloc]initWithTitle:@"TWITTER"
        message:@"twitter posting"
        delegate:self
        cancelButtonTitle:@"OK OK OK "
                                                        otherButtonTitles:  nil];
            [twitterAlert show];
            break;
        }
        default:
            break;
    }
}

@end
