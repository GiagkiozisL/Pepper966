//
//  PPRTracklistParser.h
//  Pepper966
//
//  Created by Akis on 1/8/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface PPRTracklistParser : NSObject

+ (NSMutableDictionary *)showTrackList:(NSMutableDictionary *)trackList success:(void (^)(id jsonObject))success failure:(void (^)(NSError *error))failure;

@end
