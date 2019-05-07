//
//  UIImageView+GYProgressView.m
//  GYWebImage
//
//  Created by lyons on 2017/11/10.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "UIImageView+GYProgressView.h"
#import "GYCircleProgressView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define TAG_PROGRESS_VIEW 149462
static CGFloat const kAnimationTime = .6;
static CGFloat const kProgressViewWidth = 36.0f;
static CGFloat const kProgressViewWidthSmall = 22.0f;
static CGFloat const kProgressStrokeWidth = 1.5f;
static CGFloat const kProgressStrokeWidthSmall = 1.5f;
@implementation UIImageView (GYProgressView)
@dynamic progressViewType;

- (void)addProgressViewWithType:(NPProgressViewType)progressViewType{
    GYCircleProgressView *progressV = (GYCircleProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!progressV) {
        CGFloat progressViewWidth = ((progressViewType==NPProgressViewTypeCircle)?kProgressViewWidth:kProgressViewWidthSmall);
        GYCircleProgressView *progressView = [[GYCircleProgressView alloc]initWithFrame:CGRectMake((self.frame.size.width-progressViewWidth)/2, (self.frame.size.height-progressViewWidth)/2, progressViewWidth, progressViewWidth)];
        [self addSubview:progressView];
        progressView.tag = TAG_PROGRESS_VIEW;
        //在这里可以修改一些属性
        switch (progressViewType) {
            case NPProgressViewTypeCircle:
            {
                progressView.progressStrokeWidth = kProgressStrokeWidth;
            }
                break;
            case NPProgressViewTypeCircleSmall:
            {
                progressView.progressStrokeWidth = kProgressStrokeWidthSmall;
            }
                break;
            default:
                break;
        }
        progressView.progressColor = [UIColor blackColor];//加载好color
        progressView.progressTrackColor = [UIColor whiteColor];//未加载color
    }
}

- (void)updateProgress:(CGFloat)progress{
    GYCircleProgressView *progressView = (GYCircleProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        progressView.progressValue = progress;
    }
}

- (void)removeProgressView{
    GYCircleProgressView *progressView = (GYCircleProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        progressView.hidden = YES;
        [progressView removeFromSuperview];
    }
}

- (void)sd_setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder animated:(BOOL)animated
{
    __weak typeof(self) wself = self;
    [self addProgressViewWithType:NPProgressViewTypeCircle];
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        CGFloat progress = fabs(receivedSize/((CGFloat)expectedSize));
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [wself updateProgress:progress];
                        });
                    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [wself removeProgressView];
                        if (animated) {
                            if (image && cacheType == SDImageCacheTypeNone) {
                                wself.alpha = 0.0;
                                [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    wself.alpha = 1.0;
                                } completion:^(BOOL finished) {
                                    
                                }];
                            }
                        }
                    }];
}
- (void)sd_setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(BOOL isFinished,UIImage *image))completeBlock animated:(BOOL)animated
{
    __weak typeof(self) wself = self;
    [self addProgressViewWithType:NPProgressViewTypeCircle];
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        CGFloat progress = fabs(receivedSize/((CGFloat)expectedSize));
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [wself updateProgress:progress];
                        });
                    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [wself removeProgressView];
                        if (animated) {
                            if (image && cacheType == SDImageCacheTypeNone) {
                                wself.alpha = 0.0;
                                [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    wself.alpha = 1.0;
                                } completion:^(BOOL finished) {
                                    if (completeBlock) {
                                        completeBlock(finished,image);
                                    }
                                }];
                            }else{
                                if (completeBlock) {
                                    completeBlock(YES,image);
                                }
                            }
                        }
                    }];
}

- (void)sd_setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder progressViewType:(NPProgressViewType)progressViewType
{
    __weak typeof(self) wself = self;
    [self addProgressViewWithType:progressViewType];
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        CGFloat progress = fabs(receivedSize/((CGFloat)expectedSize));
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [wself updateProgress:progress];
                        });
                    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [wself removeProgressView];
                        if (image && cacheType == SDImageCacheTypeNone) {
                            wself.alpha = 0.0;
                            [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                wself.alpha = 1.0;
                            } completion:^(BOOL finished) {
                                
                            }];
                        }
                    }];
}

- (void)sd_setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder progressViewType:(NPProgressViewType)progressViewType completed:(void(^)(BOOL isFinished,UIImage *image))completeBlock animated:(BOOL)animated
{
    __weak typeof(self) wself = self;
    [self addProgressViewWithType:progressViewType];
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        CGFloat progress = fabs(receivedSize/((CGFloat)expectedSize));
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [wself updateProgress:progress];
                        });
                    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [wself removeProgressView];
                        if (animated) {
                            if (image && cacheType == SDImageCacheTypeNone) {
                                wself.alpha = 0.0;
                                [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    wself.alpha = 1.0;
                                } completion:^(BOOL finished) {
                                    if (completeBlock) {
                                        completeBlock(finished,image);
                                    }
                                }];
                            }else{
                                if (completeBlock) {
                                    completeBlock(YES,image);
                                }
                            }
                        }else{
                            if (completeBlock) {
                                completeBlock(image,image);
                            }
                        }
                    }];
}
@end
