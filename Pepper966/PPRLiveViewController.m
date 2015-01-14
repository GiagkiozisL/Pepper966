//
//  FirstViewController.m
//  Pepper966
//
//  Created by Akis on 12/23/14.
//  Copyright (c) 2014 flowerApps. All rights reserved.
//

#import "PPRLiveViewController.h"
#import "PPRProducer.h"
#import "PPRPepperer.h"
#import "PPRTrackInfo.h"
#import "TFHpple.h"
#import "Reachability.h"

#define BaseUrl @"http://188.138.125.221:9992/listen.pls"
#define HistoryUrl @"http://www.radiojar.com/api/stations/pepper/tracks/"
#define Player @"http://www.pepper966.gr/player/"
#define NowPlaying @"http://www.radiojar.com/api/stations/pepper/now_playing/"

@interface PPRLiveViewController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation PPRLiveViewController
@synthesize playBtn;
@synthesize statusLbl;
@synthesize player;
@synthesize producerLbl;
@synthesize profilePic;
@synthesize cdAlbumImg;
@synthesize onAirLbl;
@synthesize producerView;
BOOL isPlaying = NO;
@synthesize trackIndicator;

CGFloat screenSizeRight;
UIButton *playerBtn;
UIImageView *producerAvatar;
UILabel *producerName;
NSString *tempProName;
UILabel *artistLabel;
UILabel *trackLabel;
UIImageView *trackImg;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    playerBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, -70 , 70, 70)];
    [playerBtn setImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
    [playerBtn addTarget:self action:@selector(startPlayer:) forControlEvents:UIControlEventTouchDown];
    playerBtn.layer.cornerRadius = 35;
    playerBtn.clipsToBounds = YES;
    [self.view addSubview:playerBtn];
    
    producerAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(254.0, 700.0, 50.0, 50.0)];
    producerAvatar.layer.cornerRadius = 25;
    producerAvatar.clipsToBounds = YES;
    producerAvatar.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:producerAvatar];
    
    screenSizeRight =  self.view.bounds.size.width - 60.0;
    
    playBtn.layer.cornerRadius = 35;
    playBtn.clipsToBounds = YES;
    
    if ([self checkForWIFIConnection]) {
        [self intializeNowPlayingTrack];
        UIActivityIndicatorView *waitForLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 20.0, 20.0)];
        waitForLoadingIndicator.hidesWhenStopped = YES;
        [waitForLoadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [waitForLoadingIndicator startAnimating];
        [self.view addSubview:waitForLoadingIndicator];
    
    NSURL *url = [NSURL URLWithString:BaseUrl];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    
    NSURL *urlPepper = [NSURL URLWithString:@"http://www.pepper966.gr"];
    NSData *pepperdata = [NSData dataWithContentsOfURL:urlPepper];
    
    TFHpple *pepperParser = [TFHpple hppleWithHTMLData:pepperdata];
    NSString *pepperXpathQueryString = @"//li[@class='on-air-dj']/h2/a";
    NSArray *pepperNodes = [pepperParser searchWithXPathQuery:pepperXpathQueryString];
  
    for (TFHppleElement *element in pepperNodes) {
    
        NSString *giveMeUrl = [NSString stringWithFormat:@"%@", [element objectForKey:@"href"]];
        
        PPRProducer *produc = [[PPRProducer alloc]init];
        NSMutableDictionary *namee = [[NSMutableDictionary alloc]init];
        namee = [produc showCurrentProducerName:@""
                                 profie:nil
                                    url:giveMeUrl];
        
        tempProName = [namee objectForKey:@"name"];
            producerAvatar.image = [namee objectForKey:@"image"];
        
    }
    
        [waitForLoadingIndicator stopAnimating];
    } else {
    
        NSLog(@"seems to be offline");
    }
    artistLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 280, 120, 20)];
    [artistLabel setTextColor:[UIColor whiteColor]];
    artistLabel.numberOfLines = 3;
    artistLabel.font = [UIFont fontWithName:@"Futura" size:7.0];
    [artistLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:artistLabel];
    
    trackLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 280 + artistLabel.frame.size.height, 120, 20)];

    trackLabel.textColor = [UIColor blackColor];
    [trackLabel setTextAlignment:NSTextAlignmentRight];
    trackLabel.font = [UIFont fontWithName:@"Futura" size:13.0];
    [self.view addSubview:trackLabel];
    
    trackImg = [[UIImageView alloc]initWithFrame:CGRectMake(230, 210, 60, 60)];
    //trackImg.image =  [UIImage imageNamed:@"pepperFlowerApps.png"];
    [self.view addSubview:trackImg];
    
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewdidappear");
    [UIView animateWithDuration:4.0
                          delay:0.0
         usingSpringWithDamping:0.75
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         CGRect frame = CGRectMake(40, 220 , 70, 70);
                         playerBtn.frame = frame;
                     }
                     completion:NULL];
    
    [UIView animateWithDuration:3.0
                          delay:2.0
         usingSpringWithDamping:0.30
          initialSpringVelocity:0
                        options:0
                     animations:^{
                        CGRect frame2 = CGRectMake(screenSizeRight, producerView.frame.origin.y + 20.0, 50.0, 50.0);
                         producerAvatar.frame = frame2;
                     } completion:NULL];
    producerName = [[UILabel alloc]initWithFrame:CGRectMake(20.0, producerView.frame.origin.y + 35.0, 250.0, 20.0)];
    producerName.text = tempProName;
    producerName.textColor = [UIColor whiteColor];
    producerName.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:producerName];

}

-(BOOL)checkForWIFIConnection {
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    Reachability* cellular = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    NetworkStatus netStatus1 = [cellular currentReachabilityStatus];
    if (netStatus!=ReachableViaWiFi && netStatus1!=ReachableViaWWAN)
    {
        
        // NSString *other1 = @"OK";
        NSString *cancelTitle = @"OK";
        UIAlertView *alertView1 = [[UIAlertView alloc]
                                   initWithTitle:@"Connection Failed"
                                   message:@"Please,check your internet connection(WiFi or Cellular)"
                                   delegate:self
                                   cancelButtonTitle:cancelTitle
                                   otherButtonTitles:  nil ];
        
        [alertView1 show];
        return NO;
    } else
        return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startPlayer:(id)sender {
    
    if (!isPlaying) {
        
        [player play];
       [self intializeNowPlayingTrack];
        [playerBtn setImage:[UIImage imageNamed:@"pauseBtn.png"] forState:UIControlStateNormal];
    
     switch (player.status) {
         case 0:
            // statusLbl.text = @"Unknown";
             break;
         case 1:
             [playerBtn setImage:[UIImage imageNamed:@"pauseBtn.png"] forState:UIControlStateNormal];
           onAirLbl.shadowColor = [UIColor colorWithRed:228.0 green:0.0 blue:0.0 alpha:0.5];
             break;
         case 2:
            // statusLbl.text = @"Failed";
             break;
      }
        isPlaying = YES;
    } else {
        [player pause];
        [playerBtn setImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
        onAirLbl.shadowColor = [UIColor clearColor];
        isPlaying = NO;
    }
    
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
}

- (void)intializeNowPlayingTrack {
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
    [trackIndicator startAnimating];
    PPRTrackInfo *trackInfo = [[PPRTrackInfo alloc]init];
    [trackInfo showTrackInfoIsPlaying:mutDict success:^(id jsonObject) {
        
               artistLabel.text = [jsonObject valueForKey:@"artist"];
        trackLabel.text = [jsonObject valueForKey:@"title"];
        trackImg.image = [PPRTrackInfo cdImage];
        [trackIndicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"failure or WHAT???");
    }];
  
}

@end
