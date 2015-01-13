//
//  FirstViewController.h
//  Pepper966
//
//  Created by Akis on 1/8/15.
//  Copyright (c) 2015 flowerApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"

@interface PPRLiveViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *producerLbl;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *cdAlbumImg;
@property (weak, nonatomic) IBOutlet UILabel *onAirLbl;
@property (weak, nonatomic) IBOutlet UIView *producerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *trackIndicator;

@end

