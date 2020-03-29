//
//  HDAddWaterCommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDAddWaterCommand : HDAVSECommand

@property (nonatomic , assign) BOOL imageBg;

@property (nonatomic , strong) UIImage *image;

@property (nonatomic , strong) NSURL *fileUrl;

// 图片位置
- (void)imageLayerRectWithVideoSize:(CGRect (^) (CGSize videoSize))imageLayerRect;

@end

NS_ASSUME_NONNULL_END
