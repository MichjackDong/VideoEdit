//
//  HDMixMusicCommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDMixMusicCommand : HDAVSECommand

- (void)performWithAsset:(AVAsset *)asset mixAsset:(AVAsset *)mixAsset;

/**
 插入时间
 */
@property (nonatomic , assign) CMTime insertTime;

/**
 原音频音量 0.0~1.0
 */
@property (nonatomic , assign) float audioVolume;

/**
 配音音量 0.0~1.0
 */
@property (nonatomic , assign) float mixVolume;


@end

NS_ASSUME_NONNULL_END
