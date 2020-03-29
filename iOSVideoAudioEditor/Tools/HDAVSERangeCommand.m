//
//  HDAVSERangeCommand.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSERangeCommand.h"

@implementation HDAVSERangeCommand

- (void)performWithAsset:(AVAsset *)asset timeRange:(CMTimeRange)range {
    [super performWithAsset:asset];
    if (CMTimeCompare(self.composition.duration, CMTimeAdd(range.start, range.duration)) != 1) {
        NSAssert(NO, @"Range out of video duration");
    }
    
    //轨道裁剪
    for (AVMutableCompositionTrack * compositionTrack in [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo]) {
           [self timeRangeWithTrack:compositionTrack range:range];
    }
    
    for (AVMutableCompositionTrack * compositionTrack in [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio]) {
        [self timeRangeWithTrack:compositionTrack range:range];
    }
    self.composition.duration = range.duration;
}
//删除现有组合的后半部分以修剪
- (void)timeRangeWithTrack:(AVMutableCompositionTrack *)compositionTrack range:(CMTimeRange)range{
    
    CMTime endPoint = CMTimeAdd(range.start, range.duration);
    if (CMTimeCompare(self.composition.duration,endPoint) != -1) {
        [compositionTrack removeTimeRange:CMTimeRangeMake(endPoint,CMTimeSubtract(self.composition.duration, endPoint))];
    }
    
    if (CMTimeGetSeconds(range.start)) {
        [compositionTrack removeTimeRange:CMTimeRangeMake(kCMTimeZero, range.start)];
    }
    
   
}
@end
