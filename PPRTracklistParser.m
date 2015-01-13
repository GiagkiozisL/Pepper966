//
//  PPRTracklistParser.m
//  Pepper966
//
//  Created by Akis on 1/8/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import "PPRTracklistParser.h"

@implementation PPRTracklistParser

+ (NSMutableDictionary *)showTrackList:(NSMutableDictionary *)trackList success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://www.radiojar.com/api/stations/pepper/tracks/"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure while paring data from tracklist");
    }];
    
    [operation start];
    
    return tempDict;
}

@end
