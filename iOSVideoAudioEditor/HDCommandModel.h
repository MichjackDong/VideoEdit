//
//  HDCommandModel.h
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/28.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCommandModel : NSObject

@property (nonatomic,assign) CMTime startDuration;

@property (nonatomic,assign) CMTime duration;

@property (nonatomic,assign) CGFloat scale;

@end

NS_ASSUME_NONNULL_END
