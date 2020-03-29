//
//  HDAVSECommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.

//  编辑工具类的抽象超类

#import <Foundation/Foundation.h>
#import "HDCommandParams.h"

@interface HDAVSECommand : NSObject

@property (nonatomic,strong) HDCommandParams *composition;

- (instancetype)initWithComposition:(HDCommandParams*)composition;


/// 获取视频资源
/// @param asset AVAsset
- (void)performWithAsset:(AVAsset*)asset;

//视频合成器初始化
- (void)performWithVideoComposition;

//音频合成器初始化
- (void)performWithAudioComposition;

/**
  计算旋转角度
  @param transForm transForm
  @return 角度
  */
- (NSUInteger)degressFromTransform:(CGAffineTransform)transForm;
@end

