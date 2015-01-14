//
//  PPRFavoritesTableViewController.h
//  Pepper966
//
//  Created by Akis on 1/14/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRSwipeTableViewCell.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>

@interface PPRFavoritesTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate, SWTableViewCellDelegate,FBLoginViewDelegate>

@end
