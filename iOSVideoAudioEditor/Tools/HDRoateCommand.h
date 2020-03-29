//
//  HDRoateCommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDRoateCommand : HDAVSECommand

- (void)performWithAsset:(AVAsset *)asset degress:(NSUInteger)degress;

@end

NS_ASSUME_NONNULL_END
