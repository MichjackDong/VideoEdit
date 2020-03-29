//
//  HDReplaceMusicCommand.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDReplaceMusicCommand.h"

@implementation HDReplaceMusicCommand

- (void)performWithAsset:(AVAsset *)asset replaceAsset:(AVAsset *)replaceAsset {
    [super performWithAsset:asset];
    
    CMTime insertionPoint = kCMTimeZero;
    CMTime duration;
    
    NSError *error = nil;
    
    NSArray *originalTrack = [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio] copy];
    
    for (AVCompositionTrack *track in originalTrack) {
        [self.composition.mutableComposition removeTrack:track];
    }
    
    duration = CMTimeMinimum([replaceAsset duration], self.composition.duration);
    
    for (AVAssetTrack *audioTrack in [replaceAsset tracksWithMediaType:AVMediaTypeAudio]) {
        AVMutableCompositionTrack *compositionAudioTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:audioTrack atTime:insertionPoint error:&error];
    }
}


@end
