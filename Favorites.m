//
//  Favorites.m
//  Pepper966
//
//  Created by Akis on 1/14/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import "Favorites.h"

@implementation Favorites
@dynamic artist;
@dynamic track;
@dynamic dateCreated;
@dynamic itemKey;

- (void)awakeFromInsert {
    
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}



@end
