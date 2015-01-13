//
//  PPRSwipeTableViewCell.h
//  Pepper966
//
//  Created by Akis on 1/12/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "SWCellScrollView.h"
#import "SWLongPressGestureRecognizer.h"
#import "SWUtilityButtonTapGestureRecognizer.h"
#import "NSMutableArray+SWUtilityButtons.h"

@class PPRSwipeTableViewCell;

typedef NS_ENUM(NSInteger, SWCellState) {
    
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight,
};

@protocol SWTableViewCellDelegate <NSObject>
@optional
- (void)swipeableTableViewCell:(PPRSwipeTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(PPRSwipeTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(PPRSwipeTableViewCell *)cell scrollingToState:(SWCellState)state;
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(PPRSwipeTableViewCell *)cell;
- (BOOL)swipeableTableViewCell:(PPRSwipeTableViewCell *)cell canSwipeToState:(SWCellState)state;

@end

@interface PPRSwipeTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *leftUtilityButtons;
@property (nonatomic, copy) NSArray *rightUtilityButtons;
@property (nonatomic, weak) id <SWTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)hideUtilityButtonsAnimated:(BOOL)animated;

@end
