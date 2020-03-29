//
//  HDExportCommand.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDAVSECommand.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface HDExportCommand : HDAVSECommand

@property (nonatomic,strong) AVAssetExportSession *exportSession;
@property (nonatomic , assign) NSInteger videoQuality;

- (void)performSaveByPath:(NSString *)path;
- (void)performSaveAsset:(AVAsset *)asset byPath:(NSString *)path;

@end

