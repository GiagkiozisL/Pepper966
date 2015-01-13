//
//  PPRTrackInfo.m
//  Pepper966
//
//  Created by Akis on 12/29/14.
//  Copyright (c) 2014 flowerApps. All rights reserved.
//

#import "PPRTrackInfo.h"
#import "TFHpple.h"
#define dynamicCurrentTrackUrl  @"https://i.ytimg.com/vi/_9KjpM0tKFw/0.jpg"

@implementation PPRTrackInfo
@synthesize songArtist;
@synthesize songTitle;
@synthesize cdImage;

- (void)setCdImage:(UIImage *)cdImage {
    NSURL *urlimage = [NSURL URLWithString:@"https://i.ytimg.com/vi/_9KjpM0tKFw/0.jpg"];
    NSData *dataImg = [NSData dataWithContentsOfURL:urlimage];
    self.cdImage = [UIImage imageWithData:dataImg];
}

+ (UIImage *)cdImage {
    UIImageView *cdImage = [[UIImageView alloc]init];
    NSURL *urlimage = [NSURL URLWithString:dynamicCurrentTrackUrl];
    NSData *dataImg = [NSData dataWithContentsOfURL:urlimage];
    cdImage.image = [UIImage imageWithData:dataImg];
    return cdImage.image;
}

- (void)showTrackInfoIsPlaying:(NSMutableDictionary*)mutDict success:(void (^)(id jsonObject))success failure:(void (^)(NSError *error))failure  {
    
    NSURL *urlNowPlaying = [NSURL URLWithString:@"http://www.radiojar.com/api/stations/pepper/now_playing/"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNowPlaying];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (success) {
            success(responseObject);
        }
//        NSString *artist = [responseObject valueForKey:@"artist"];
//        NSString *title = [responseObject valueForKey:@"title"];
//        [mutDict setObject:artist forKey:@"artist"];
//        [mutDict setObject:title forKey:@"title"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error whigle retrieving history data : %@",[error description]);
    }];
    
    [operation start];
   
}

@end
