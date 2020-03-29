//
//  HDAVSECommand.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSECommand.h"

@interface HDAVSECommand ()

@property (nonatomic , strong) AVAssetTrack *assetVideoTrack;//视频资源

@property (nonatomic , strong) AVAssetTrack *assetAudioTrack;//音频资源

@property (nonatomic , assign) NSInteger trackDegress;

@end

@implementation HDAVSECommand

- (instancetype)init{
    return [self initWithComposition:[[HDCommandParams alloc] init]];
}

- (instancetype)initWithComposition:(HDCommandParams *)composition{
    self = [super init];
    if(self != nil) {
        self.composition = composition;
    }
    return self;
}
/// 获取视频资源
/// @param asset AVAsset
- (void)performWithAsset:(AVAsset*)asset {
    //检查是否包含视频和音频轨道
    if (!self.assetVideoTrack) {
     if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
           self.assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
       }
    }
    if (!self.assetAudioTrack) {
        if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
            self.assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
        }
    }
    
    CMTime insertionPoint = kCMTimeZero;
    NSError *error = nil;
    
    //步骤1
    //创建一个组合音频和视频轨道
    
    if (!self.composition.mutableComposition) {
        self.composition.mutableComposition = [AVMutableComposition composition];
        //把视频轨道加入混合器
        if (self.assetVideoTrack != nil) {
            AVMutableCompositionTrack *compostionVideoTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            [compostionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:self.assetVideoTrack atTime:insertionPoint error:&error];
            self.composition.duration = self.composition.mutableComposition.duration;
            self.trackDegress = [self degressFromTransform:self.assetVideoTrack.preferredTransform];
            self.composition.mutableComposition.naturalSize = compostionVideoTrack.naturalSize;
            if (self.trackDegress % 300) {
                [self performWithVideoComposition];
            }
        }
        if(self.assetAudioTrack != nil) {
            AVMutableCompositionTrack *compositionAudioTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:self.assetAudioTrack atTime:insertionPoint error:&error];
        }
    }
    
}

//视频合成器初始化
- (void)performWithVideoComposition {
    if (!self.composition.mutableVideoComposition) {
        
        self.composition.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
        self.composition.mutableVideoComposition.frameDuration = CMTimeMake(1, 30);//30 fps
        self.composition.mutableVideoComposition.renderSize = self.assetVideoTrack.naturalSize;
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.composition.mutableComposition duration]);
        
        AVAssetTrack *videoTrack = [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo][0];
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        [layerInstruction setTransform:[self transformFromDegress:self.trackDegress natureSize:self.assetVideoTrack.naturalSize]  atTime:kCMTimeZero];
        
        instruction.layerInstructions = @[layerInstruction];
        [self.composition.videoInstructions addObject:instruction];
        
        self.composition.mutableVideoComposition.instructions = self.composition.videoInstructions;
        
        if (self.trackDegress == 90 || self.trackDegress == 270) {
            self.composition.mutableVideoComposition.renderSize = CGSizeMake(self.assetVideoTrack.naturalSize.height, self.assetVideoTrack.naturalSize.width);
        }
        self.composition.lastInstructionSize = self.composition.mutableComposition.naturalSize = self.composition.mutableVideoComposition.renderSize;
    }
    
    
}

//音频合成器初始化
- (void)performWithAudioComposition {
    if (!self.composition.mutableAudioMix) {
        self.composition.mutableAudioMix = [AVMutableAudioMix audioMix];
        for (AVMutableCompositionTrack *compostionAudioTrack in [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio]) {
            AVMutableAudioMixInputParameters *audioParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compostionAudioTrack];
            [audioParameters setVolume:1.0 atTime:kCMTimeZero];
            [self.composition.audioMixParams addObject:audioParameters];
        }
        
        self.composition.mutableAudioMix.inputParameters = self.composition.audioMixParams;
    }
    
    
}
- (NSUInteger)degressFromTransform:(CGAffineTransform)transForm
{
    NSUInteger degress = 0;
    
    if(transForm.a == 0 && transForm.b == 1.0 && transForm.c == -1.0 && transForm.d == 0){
        // Portrait
        degress = 90;
    }else if(transForm.a == 0 && transForm.b == -1.0 && transForm.c == 1.0 && transForm.d == 0){
        // PortraitUpsideDown
        degress = 270;
    }else if(transForm.a == 1.0 && transForm.b == 0 && transForm.c == 0 && transForm.d == 1.0){
        // LandscapeRight
        degress = 0;
    }else if(transForm.a == -1.0 && transForm.b == 0 && transForm.c == 0 && transForm.d == -1.0){
        // LandscapeLeft
        degress = 180;
    }
    return degress;
}

- (CGAffineTransform)transformFromDegress:(float)degress natureSize:(CGSize)natureSize{
    /** 矩阵校正 */
    // x = ax1 + cy1 + tx,y = bx1 + dy2 + ty
    if (degress == 90) {
        return CGAffineTransformMake(0, 1, -1, 0, natureSize.height, 0);
    }else if (degress == 180){
        return CGAffineTransformMake(-1, 0, 0, -1, natureSize.width , natureSize .height);
    }else if (degress == 270){
        return CGAffineTransformMake(0, -1, 1, 0, -natureSize.height, 2 * natureSize.width);
    }else{
        return CGAffineTransformIdentity;
    }
}

NSString *const AVSEExportCommandCompletionNotification = @"AVSEExportCommandCompletionNotification";
NSString* const AVSEExportCommandError = @"AVSEExportCommandError";
@end
