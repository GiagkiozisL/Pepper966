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
#import "FavoritesStore.h"

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
NSString *selectedSong;
NSString *selectedArtist;
NSString *selectedTrack;

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

- (void)fbLogin {
    if (FBSession.activeSession.isOpen) {
        NSLog(@"is logged in already");
    } else {
    FBLoginView *loginView = [[FBLoginView alloc]init];
    loginView.delegate = self;
    
    }
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@ - %@",tempArtist, tempTitle]];
      //  [controller addImage:imageTemp];
        
        [self presentViewController:controller animated:YES completion:Nil];
    } else {
        NSLog(@"unavailable!");
    }

    
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

    cell.leftUtilityButtons = leftUtilityButtons;
    cell.delegate = self;
    
    cell.trackArtist.text = [reversedArtistArray objectAtIndex:indexPath.row];
    cell.trackTitle.text = [reversedTitleArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    selectedSong = [NSString stringWithFormat:@"%@ - %@",[reversedArtistArray objectAtIndex:indexPath.row],[reversedTitleArray objectAtIndex:indexPath.row]];
    selectedArtist = [NSString stringWithFormat:@"%@",[reversedArtistArray objectAtIndex:indexPath.row]];
    selectedTrack = [NSString stringWithFormat:@"%@",[reversedTitleArray objectAtIndex:indexPath.row]];
    NSLog(@"selected song: %@",selectedSong);
}

#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(PPRSwipeTableViewCell *)cell
                        didTriggerLeftUtilityButtonWithIndex:(NSInteger)index  {
    
   
    switch (index) {
        case 0:
        {
            
            Favorites *newFaver = [[FavoritesStore sharedStore] createItem];
            
            newFaver.artist = selectedArtist;
            newFaver.track = selectedTrack;
            newFaver.dateCreated = [NSDate date];
            
            
            
          UIAlertView *likedAlert = [[UIAlertView alloc]initWithTitle:@"Favorites reminder!"
        message:@"saved to fav!"
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
            
            [self fbLogin];
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

#pragma mark - FBLoginViewDelegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"FB LOGGED IN SUCCESSFULLY WITH NAME ID : %@",user.name);
}

@end
