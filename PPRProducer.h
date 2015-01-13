//
//  PPRProducer.h
//  Pepper966
//
//  Created by Akis on 12/23/14.
//  Copyright (c) 2014 flowerApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PPRProducer : NSObject

@property (nonatomic, retain) NSString *djName;
@property (nonatomic, retain) UIImage *profileImg;

+ (NSMutableDictionary *)currentProducer;
+ (NSMutableDictionary *)previousProducer;
+ (NSMutableDictionary *)nextProducer;
- (NSMutableDictionary *)showCurrentProducerName:(NSString *)name profie:(UIImage *)imag url:(NSString *)href;
- (void)showPreviousProducerName:(NSString *)name profile:(UIImage *)imag;
- (void)showNextProducerName:(NSString *)name profile:(UIImage *)imag;

@end
