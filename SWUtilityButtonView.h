//
//  SWUtilityButtonView.h
//  Pepper966
//
//  Created by Akis on 1/8/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPRSwipeTableViewCell;

#define kUtilityButtonWidthDefault 90

@interface SWUtilityButtonView : UIView

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(PPRSwipeTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;
- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(PPRSwipeTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@property (nonatomic, weak, readonly) PPRSwipeTableViewCell *parentCell;
@property (nonatomic, copy) NSArray *utilityButtons;
@property (nonatomic, assign) SEL utilityButtonSelector;

- (void)pushBackgroundColors;
- (void)popBackgroundColors;

@end
