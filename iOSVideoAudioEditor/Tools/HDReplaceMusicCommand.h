//
//  HDReplaceMusicCommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDReplaceMusicCommand : HDAVSECommand

- (void)performWithAsset:(AVAsset *)asset replaceAsset:(AVAsset *)replaceAsset;

@end

NS_ASSUME_NONNULL_END
