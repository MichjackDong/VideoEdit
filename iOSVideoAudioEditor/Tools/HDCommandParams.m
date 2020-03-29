//
//  HDCommandParams.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDCommandParams.h"


@implementation HDCommandParams

- (NSMutableArray<AVMutableAudioMixInputParameters *> *)audioMixParams {
    if (!_audioMixParams) {
        _audioMixParams = [[NSMutableArray alloc] init];
    }
    return _audioMixParams;
}
- (NSMutableArray<AVMutableVideoCompositionInstruction *> *)videoInstructions {
    if (!_videoInstructions) {
        _videoInstructions = [[NSMutableArray alloc] init];
    }
    return _videoInstructions;
}

@end
