//
//  HDVideoSpeedCommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSECommand.h"
#import <AVFoundation/AVFoundation.h>
#import "HDCommandModel.h"

@interface HDVideoSpeedCommand : HDAVSECommand

- (void)performWithAsset:(AVAsset *)asset scale:(CGFloat)scale;

- (void)performWithAsset:(AVAsset *)asset models:(NSArray <HDCommandModel *> *)gearboxModels;

@end

