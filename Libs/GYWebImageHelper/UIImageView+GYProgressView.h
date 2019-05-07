//
//  UIImageView+GYProgressView.h
//  GYWebImage
//
//  Created by lyons on 2017/11/10.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NPProgressViewTypeCircle,
    NPProgressViewTypeCircleSmall
}NPProgressViewType;

@interface UIImageView (GYProgressView)

/**
 进度条样式
 */
@property (nonatomic, assign)NPProgressViewType progressViewType;

/**
 环形加载图片动画
 
 @param url url
 @param placeholder placeholder
 @param animated animated
 */
- (void)sd_setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated;

/**
 环形加载图片动画（回调）
 
 @param url url
 @param placeholder placeholder
 @param completeBlock 回调
 @param animated animated
 */
- (void)sd_setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(BOOL isFinished,UIImage *image))completeBlock animated:(BOOL)animated;

/**
 环形加载图片动画
 
 @param url url
 @param placeholder placeholder
 */
- (void)sd_setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder progressViewType:(NPProgressViewType)progressViewType;

/**
 环形加载图片动画（回调）
 
 @param url url
 @param placeholder placeholder
 @param completeBlock 回调
 */
- (void)sd_setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder progressViewType:(NPProgressViewType)progressViewType completed:(void(^)(BOOL isFinished,UIImage *image))completeBlock animated:(BOOL)animated;
@end
