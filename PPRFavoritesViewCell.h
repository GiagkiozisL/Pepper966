//
//  PPRFavoritesViewCell.h
//  Pepper966
//
//  Created by Akis on 1/14/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRSwipeTableViewCell.h"

@interface PPRFavoritesViewCell : PPRSwipeTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *track;
@property (weak, nonatomic) IBOutlet UILabel *dateCreated;

@end
