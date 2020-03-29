//
//  HDCommandParams.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//  视频参数模型

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const AVSEEditCommandCompletionNotification;//编辑完成
extern NSString *const AVSEExportCommandCompletionNotification;//导出视频完成

extern NSString *const AVSEExportCommandError;




@interface HDCommandParams : NSObject

//AVMutableComposition 可以用来操作音频和视频的组合
@property (nonatomic,strong) AVMutableComposition *mutableComposition;
//AVMutableVideoComposition 可以用来对视频进行操作
@property (nonatomic,strong) AVMutableVideoComposition *mutableVideoComposition;
//AVMutableAudioMix 类是给视频添加音频
@property (nonatomic,strong) AVMutableAudioMix *mutableAudioMix;
//视频时长(变速/裁剪后)
@property (nonatomic,assign) CMTime duration;
//视频分辨率
@property (nonatomic,copy) NSString *presetName;
//视频质量
@property (nonatomic,assign) NSInteger videoQuality;
//导出视频格式
@property (nonatomic,copy) AVFileType  fileType;
/*
 AVMutableVideoCompositionInstruction和AVMutableVideoCompositionLayerInstruction 一般都是配合使用，用来给视频添加水印或者旋转视频方向
 */

//视频操作数组
@property (nonatomic,strong) NSMutableArray <AVMutableVideoCompositionInstruction*> *videoInstructions;
//音频操作数组
@property (nonatomic,strong) NSMutableArray <AVMutableAudioMixInputParameters*> *audioMixParams;

//画布父容器
@property (nonatomic,strong) CALayer *parentLayer;
//原视频容器
@property (nonatomic,assign) CALayer *videoLayer;

@property (nonatomic , assign) CGSize lastInstructionSize;

@end

NS_ASSUME_NONNULL_END
