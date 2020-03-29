//
//  HDAVSEVideoMixCommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDAVSEVideoMixCommand : HDAVSECommand

- (void)performWithAsset:(AVAsset *)asset mixAsset:(AVAsset *)mixAsset;

- (void)performWithAssets:(NSArray *)assets;

@end

NS_ASSUME_NONNULL_END
