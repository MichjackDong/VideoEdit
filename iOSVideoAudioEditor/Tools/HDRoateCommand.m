//
//  HDRoateCommand.m
//  iOSVideoAudioEditor
//
//  Created by jackDong on 2020/3/29.
//  Copyright © 2020 jackDong. All rights reserved.
//

#import "HDRoateCommand.h"

@implementation HDRoateCommand

- (void)performWithAsset:(AVAsset *)asset degress:(NSUInteger)degress {
    [super performWithAsset:asset];
    [super performWithVideoComposition];
    
    if (self.composition.mutableVideoComposition.instructions.count > 1) {//多个视频分辨率视频合并旋转
        return;
    }
    
    degress -= degress % 360 % 90;
    for (AVMutableVideoCompositionInstruction *instruction in self.composition.mutableVideoComposition.instructions) {
            
            AVMutableVideoCompositionLayerInstruction *layerInstruction = (AVMutableVideoCompositionLayerInstruction *)(instruction.layerInstructions)[0];
            CGAffineTransform t1;
            CGAffineTransform t2;
            CGSize renderSize;
            
            // 角度调整
            degress -= degress % 360 % 90;
            
            if (degress == 90) {
                t1 = CGAffineTransformMakeTranslation(self.composition.mutableVideoComposition.renderSize.height, 0.0);
                renderSize = CGSizeMake(self.composition.mutableVideoComposition.renderSize.height, self.composition.mutableVideoComposition.renderSize.width);
            }else if (degress == 180){
                t1 = CGAffineTransformMakeTranslation(self.composition.mutableVideoComposition.renderSize.width, self.composition.mutableVideoComposition.renderSize.height);
                renderSize = CGSizeMake(self.composition.mutableVideoComposition.renderSize.width, self.composition.mutableVideoComposition.renderSize.height);
            }else if (degress == 270){
                t1 = CGAffineTransformMakeTranslation(0.0, self.composition.mutableVideoComposition.renderSize.width);
                renderSize = CGSizeMake(self.composition.mutableVideoComposition.renderSize.height, self.composition.mutableVideoComposition.renderSize.width);
            }else{
                t1 = CGAffineTransformMakeTranslation(0.0, 0.0);
                renderSize = CGSizeMake(self.composition.mutableVideoComposition.renderSize.width, self.composition.mutableVideoComposition.renderSize.height);
            }
            
            // Rotate transformation
            t2 = CGAffineTransformRotate(t1, (degress / 180.0) * M_PI );
            
            self.composition.mutableComposition.naturalSize = self.composition.mutableVideoComposition.renderSize = renderSize;
            
            CGAffineTransform existingTransform;
            
            if (![layerInstruction getTransformRampForTime:[self.composition.mutableComposition duration] startTransform:&existingTransform endTransform:NULL timeRange:NULL]) {
                [layerInstruction setTransform:t2 atTime:kCMTimeZero];
            } else {
                CGAffineTransform newTransform =  CGAffineTransformConcat(existingTransform, t2);
                [layerInstruction setTransform:newTransform atTime:kCMTimeZero];
            }
            
            instruction.layerInstructions = @[layerInstruction];
            
        }
        
        // 将容器大小旋转，若没有anmaitionTool的修改，则直接跳过此步
        if (self.composition.videoLayer || self.composition.parentLayer) {
            
            for (CALayer *sublayer in self.composition.parentLayer.sublayers) {
                if (sublayer == self.composition.videoLayer) {
                    continue;
                }
                [self converRect:sublayer naturalRenderSize:self.composition.mutableVideoComposition.renderSize renderSize:self.composition.mutableVideoComposition.renderSize];
                sublayer.transform = CATransform3DRotate(sublayer.transform, -(degress / 180.0 * M_PI), 0, 0, 1);
            }
            
            if (degress == 90 || degress == 270) {
                self.composition.videoLayer.frame = CGRectMake(0, 0, self.composition.videoLayer.bounds.size.height, self.composition.videoLayer.bounds.size.width);
                self.composition.parentLayer.frame = CGRectMake(0, 0, self.composition.parentLayer.bounds.size.height, self.composition.parentLayer.bounds.size.width);
            }
            
        }
       
    }

- (void)converRect:(CALayer *)layer naturalRenderSize:(CGSize)size renderSize:(CGSize)renderSize{
    
    if (!CGSizeEqualToSize(size, renderSize)) {
        // 还原绝对位置
        CGRect relativeRect = CGRectMake(layer.frame.origin.x / size.width, layer.frame.origin.y / size.height, layer.bounds.size.width / size.width, layer.bounds.size.height / size.height);
        
        layer.frame = CGRectMake(renderSize.width * relativeRect.origin.x,renderSize.height * relativeRect.origin.y,renderSize.width * relativeRect.size.width, renderSize.height * relativeRect.size.height);
        
    }
}


@end
