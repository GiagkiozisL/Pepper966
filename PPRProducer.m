//
//  PPRProducer.m
//  Pepper966
//
//  Created by Akis on 12/23/14.
//  Copyright (c) 2014 flowerApps. All rights reserved.
//

#import "PPRProducer.h"
#import "TFHpple.h"

#define CurrentUrl @"http://www.pepper966.gr/show/yiannis-kastanakis/"

@implementation PPRProducer
@synthesize djName;
@synthesize profileImg;

- (id)init {
    if (self) {
        
    }
    return self;
}

+ (NSMutableDictionary *)currentProducer {
    NSMutableDictionary *currentDict = [[NSMutableDictionary alloc]init];
    NSString *strng = @"current test";
    UIImage *img = [UIImage imageNamed:@"profileCV.jpeg"];
    [currentDict setObject:strng forKey:@"name"];
    [currentDict setObject:img forKey:@"image"];
    
    return currentDict;
}

+ (NSMutableDictionary *)previousProducer {

    NSMutableDictionary *previousDict = [[NSMutableDictionary alloc] init];
    return previousDict;
}

+ (NSMutableDictionary *)nextProducer {

    NSMutableDictionary *nextDict = [[NSMutableDictionary alloc]init];
    return nextDict;
}

- (NSMutableDictionary *)showCurrentProducerName:(NSString *)name
                         profie:(UIImage *)imag
                            url:(NSString *)href {
    NSLog(@"show href from main controller:%@",href);
    
    NSURL *url = [NSURL URLWithString:href];
    NSData *currentProData = [NSData dataWithContentsOfURL:url];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:currentProData];
    NSString *curXpathQueryString = @"//div[@class='post-featured']/img";
    NSString *curXpathQueryString2 = @"//li[@class='on-air-dj']/h2/a";
    NSArray *currNodes = [parser searchWithXPathQuery:curXpathQueryString];
    NSArray *currNodes2 = [parser searchWithXPathQuery:curXpathQueryString2];
    
    for (TFHppleElement *element in currNodes) {
        
        NSURL *url = [NSURL URLWithString:[element objectForKey:@"src"]];
        NSData *dataimg = [NSData dataWithContentsOfURL:url];
        profileImg = [UIImage imageWithData:dataimg];
        
        if (!dataimg) {
            profileImg = [UIImage imageNamed:@"pepperFlower.png"];
        }
     }
    
    for (TFHppleElement *element2 in currNodes2) {
    
       djName = [[element2 firstChild] content];
    }
    NSMutableDictionary *curDict = [PPRProducer currentProducer];
    [curDict setObject:djName forKey:@"name"];
    [curDict setObject:profileImg forKey:@"image"];
    
    return curDict;
}

- (void)showPreviousProducerName:(NSString *)name profile:(UIImage *)imag {

    name = @"previousName";
}

- (void)showNextProducerName:(NSString *)name profile:(UIImage *)imag {

    name = @"nextName";
}

@end
