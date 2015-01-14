//
//  PPRFavoritesViewCell.m
//  Pepper966
//
//  Created by Akis on 1/14/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import "PPRFavoritesViewCell.h"

@implementation PPRFavoritesViewCell
@synthesize artist;
@synthesize track;
@synthesize dateCreated;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
