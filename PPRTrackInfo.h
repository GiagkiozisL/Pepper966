//
//  PPRTrackInfo.h
//  Pepper966
//
//  Created by Akis on 12/29/14.
//  Copyright (c) 2014 flowerApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface PPRTrackInfo : NSObject

@property (nonatomic, retain) NSString *songArtist;
@property (nonatomic, retain) NSString *songTitle;
@property (nonatomic, retain) UIImage *cdImage;

+ (UIImage *)cdImage;

- (void)showTrackInfoIsPlaying:(NSMutableDictionary*)mutDict success:(void (^)(id jsonObject))success failure:(void (^)(NSError *error))failure;

@end
