//
//  FavoritesStore.h
//  Pepper966
//
//  Created by Akis on 1/14/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favorites.h"

@interface FavoritesStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (Favorites *)createItem;
- (void)removeItem:(Favorites *)item;
- (BOOL)saveChanges;

@end
