//
//  HDVideoSpeedCommand.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDVideoSpeedCommand.h"


@implementation HDVideoSpeedCommand

- (void)performWithAsset:(AVAsset *)asset scale:(CGFloat)scale{
    [super performWithAsset:asset];
    
    CMTime insertPoint = kCMTimeZero;
    for (AVMutableVideoCompositionInstruction *instruction in self.composition.videoInstructions) {
        CMTime duration = instruction.timeRange.duration;
        [instruction setTimeRange:CMTimeRangeMake(insertPoint, CMTimeMake(duration.value / scale, duration.timescale))];
        insertPoint = CMTimeAdd(instruction.timeRange.start, instruction.timeRange.duration);
    }
    
    
    [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo] enumerateObjectsUsingBlock:^(AVMutableCompositionTrack  *videoTrack, NSUInteger idx, BOOL * _Nonnull stop) {
        //        AVMutableVideoCompositionInstruction *instruction = self.composition.instructions[1];
        [videoTrack scaleTimeRange:videoTrack.timeRange toDuration: CMTimeMake(videoTrack.timeRange.duration.value / scale, videoTrack.timeRange.duration.timescale)];
    }];

    [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio] enumerateObjectsUsingBlock:^(AVMutableCompositionTrack  *audioTrack, NSUInteger idx, BOOL * _Nonnull stop) {
        [audioTrack scaleTimeRange:audioTrack.timeRange toDuration: CMTimeMake(audioTrack.timeRange.duration.value / scale, audioTrack.timeRange.duration.timescale)];
    }];
    
    self.composition.duration = CMTimeMultiplyByFloat64(self.composition.duration, 1 / scale);
    
    // 保证最后一条能到视频最后
    AVMutableVideoCompositionInstruction *instruction = [self.composition.videoInstructions lastObject];
    [instruction setTimeRange:CMTimeRangeMake(instruction.timeRange.start, CMTimeSubtract(self.composition.duration, instruction.timeRange.start))];
}


- (void)performWithAsset:(AVAsset *)asset models:(NSArray<HDCommandModel *> *)gearboxModels{
    [super performWithAsset:asset];
    
    if (self.composition.videoInstructions.count > 1) {
        return;
    }
    
    CMTime scaleDuration = kCMTimeZero;
    CMTime duration = kCMTimeZero;
    
    for (HDCommandModel *model in gearboxModels) {
        
        scaleDuration = CMTimeMultiplyByFloat64(model.duration, 1 / model.scale);
        // 视图变速
        for (AVMutableCompositionTrack  *videoTrack in [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo]) {
            [videoTrack scaleTimeRange:CMTimeRangeMake(model.startDuration, model.duration) toDuration:scaleDuration];
        }
        
        // 音频变速
        for (AVMutableCompositionTrack  *audioTrack in [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio]) {
            
            [audioTrack scaleTimeRange:CMTimeRangeMake(model.startDuration, model.duration) toDuration: scaleDuration];
        }
        
        // instruction变速
        duration = CMTimeAdd(duration, model.duration);
        
    }
    
    
    for (AVMutableVideoCompositionInstruction *instruction in self.composition.videoInstructions) {
        [instruction setTimeRange:CMTimeRangeMake(kCMTimeZero,self.composition.duration)];
    }
    
}

@end
