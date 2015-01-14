//
//  FavoritesStore.m
//  Pepper966
//
//  Created by Akis on 1/14/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import "FavoritesStore.h"

@interface FavoritesStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation FavoritesStore

+ (instancetype)sharedStore {
    
    static FavoritesStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        // Read in Pepper966.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Where does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (NSString *)itemArchivePath {
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)loadAllItems {
    
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSEntityDescription *entDescr = [NSEntityDescription entityForName:@"Favorites"
                                                    inManagedObjectContext:_context];
        request.entity = entDescr;
        NSSortDescriptor *sortDescr = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated"
                                                                    ascending:YES];
        request.sortDescriptors = @[sortDescr];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        self.privateItems = [[NSMutableArray alloc]initWithArray:result];
    }
    
}

- (NSArray *)allItems {
    
    return [self.privateItems copy];
}

- (Favorites *)createItem {
    
    Favorites *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Favorites"
                                                       inManagedObjectContext:_context];
    [self.privateItems addObject:newItem];
    return newItem;
}

- (void)removeItem:(Favorites *)item {
    
    NSString *key = item.itemKey;
    
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
    
}

- (BOOL)saveChanges {
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

@end
