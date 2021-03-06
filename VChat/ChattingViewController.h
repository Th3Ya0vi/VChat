//
//  ChattingViewController.h
//  VChat
//
//  Created by George Chen on 2/6/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ChattingViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource> {
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, strong) PFUser *localUser;
@property (nonatomic, strong) PFUser *remoteUser;

@end
