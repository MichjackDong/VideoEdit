//
//  HDExportCommand.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDExportCommand.h"

@interface HDExportCommand ()

@property (nonatomic, assign)CGFloat ratioParam;

@end

@implementation HDExportCommand

- (instancetype)initWithComposition:(HDCommandParams *)composition {
    if ([super initWithComposition:composition]) {
        self.videoQuality = 0;
    }
    return self;
}

- (void)performSaveAsset:(AVAsset *)asset byPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    // Remove Existing File
    [fileManager removeItemAtPath:path error:nil];
    
    if (self.composition.presetName.length == 0) {
        self.composition.presetName = AVAssetExportPresetHighestQuality;
    }
    if (!self.composition.fileType) {
        self.composition.fileType = AVFileTypeMPEG4;
    }
    self.exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:self.composition.presetName];
    self.exportSession.videoComposition = self.composition.mutableVideoComposition;
    self.exportSession.audioMix = self.composition.mutableAudioMix;
    
    self.exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, [self.composition duration]);
    self.exportSession.outputURL = [NSURL fileURLWithPath:path];
    self.exportSession.outputFileType = self.composition.fileType;
    // 这个一般设置为yes（指示输出文件应针对网络使用进行优化，例如QuickTime电影文件应支持“快速启动”）shouldOptimizeForNetworkUse
    self.exportSession.shouldOptimizeForNetworkUse = YES;
    
    if (self.videoQuality) {
        if ([self.composition.presetName isEqualToString:AVAssetExportPreset640x480]) {
            self.ratioParam = 0.02;
        }
        if ([self.composition.presetName isEqualToString:AVAssetExportPreset960x540]) {
            self.ratioParam = 0.04;
        }
        if ([self.composition.presetName isEqualToString:AVAssetExportPreset1280x720]) {
            self.ratioParam = 0.08;
        }
        
        if (self.ratioParam) {
            // 文件的最大多大的设置
            self.exportSession.fileLengthLimit = CMTimeGetSeconds(self.composition.duration) * self.ratioParam * self.composition.videoQuality * 1024 * 1024;
        }
    }
    
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (self.exportSession.status) {
            case AVAssetExportSessionStatusCompleted:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:AVSEExportCommandCompletionNotification object:self];
                break;
            }
            case AVAssetExportSessionStatusFailed:
            {
                NSLog(@"%@",self.exportSession.error);
                [[NSNotificationCenter defaultCenter] postNotificationName:AVSEExportCommandCompletionNotification object:self userInfo:@{AVSEExportCommandError:self.exportSession.error}];
                break;
            }
            case AVAssetExportSessionStatusCancelled:
            [[NSNotificationCenter defaultCenter]
             postNotificationName:AVSEExportCommandCompletionNotification
             object:self userInfo:@{AVSEExportCommandError:[NSError errorWithDomain:AVFoundationErrorDomain code:-10000 userInfo:@{NSLocalizedFailureReasonErrorKey:@"User cancel process!"}]}];
            break;
            default:
                break;
        }
    }];
}
- (void)performSaveByPath:(NSString *)path {
    [self performSaveAsset:self.composition.mutableComposition byPath:path];
}
- (void)dealloc {
    
    
}
@end
