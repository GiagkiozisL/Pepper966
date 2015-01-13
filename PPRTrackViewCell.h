//
//  PPRTrackViewCell.h
//  Pepper966
//
//  Created by Akis on 1/8/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRSwipeTableViewCell.h"

@interface PPRTrackViewCell : PPRSwipeTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackArtist;
@property (weak, nonatomic) IBOutlet UILabel *trackTitle;

@end
