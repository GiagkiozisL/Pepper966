//
//  Favorites.h
//  Pepper966
//
//  Created by Akis on 1/14/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface Favorites : NSManagedObject

@property(nonatomic, retain) NSString *artist;
@property(nonatomic, retain) NSString *track;
@property(nonatomic, retain) NSDate *dateCreated;
@property(nonatomic, retain) NSString *itemKey;

@end
