//
//  PlayViewController.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "PlayViewController.h"
#import <AVKit/AVKit.h>

@interface PlayViewController ()

@property(nonatomic, strong)AVPlayerViewController *player;

@property (nonatomic , strong) NSString *filePath;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.player = [[AVPlayerViewController alloc] init];
    
    self.player.view.frame = self.view.bounds;
    
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    
    self.player.player = [AVPlayer playerWithURL:url];
    
    self.player.showsPlaybackControls = YES;
    
    [self.view addSubview:self.player.view];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[_player player] play];
}

- (void)loadWithFilePath:(NSString *)filePath{
    self.filePath = filePath;
}
@end
