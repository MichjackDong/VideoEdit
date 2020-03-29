//
//  HDAVSERangeCommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//  裁剪视频

#import "HDAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDAVSERangeCommand : HDAVSECommand

- (void)performWithAsset:(AVAsset *)asset timeRange:(CMTimeRange)range;

@end

NS_ASSUME_NONNULL_END
