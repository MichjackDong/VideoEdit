//
//  HDMixMusicCommand.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDMixMusicCommand.h"

@implementation HDMixMusicCommand

- (instancetype)initWithComposition:(HDCommandParams *)composition {
    if (self = [super initWithComposition:composition]) {
        self.audioVolume = 0.5;
        self.mixVolume = 0.5;
        self.insertTime = kCMTimeZero;
    }
    return self;
}

- (void)performWithAsset:(AVAsset *)asset mixAsset:(AVAsset *)mixAsset {
    [super performWithAsset:asset];
    [super performWithVideoComposition];
    
    if (CMTimeCompare(self.composition.duration, _insertTime) != 1) {
        return;
    }
    
    for (AVMutableAudioMixInputParameters *inputParameters in self.composition.audioMixParams) {
        [inputParameters setVolume:self.audioVolume atTime:kCMTimeZero];
    }
    
    AVAssetTrack *audioTrack = nil;
    if ([[mixAsset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        audioTrack = [mixAsset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    AVMutableCompositionTrack *mixTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime endPoint = CMTimeAdd(_insertTime, mixAsset.duration);
    
    CMTime duration = CMTimeSubtract(CMTimeMinimum(endPoint, self.composition.duration), _insertTime);
    
    [mixTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:audioTrack atTime:_insertTime error:nil];
    
     AVMutableAudioMixInputParameters *mixParam = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:mixTrack];
    
    [mixParam setVolume:self.mixVolume atTime:_insertTime];
    [self.composition.audioMixParams addObject:mixParam];
    
    self.composition.mutableAudioMix.inputParameters = self.composition.audioMixParams;
}

@end
