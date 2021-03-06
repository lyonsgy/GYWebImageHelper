//
//  UIImage+GYExtension.m
//  GYWebImage
//
//  Created by lyons on 2017/11/10.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "UIImage+GYExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UIImageView+GYProgressView.h"

#pragma mark - UIImage
@implementation UIImage (GYExtension)

+ (UIImage *)captureWithRect:(CGRect)rect Image:(UIImage *)image {
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    image = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return image;
    
}
- (void)gy_roundImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor opaque:(BOOL)opaque completion:(void (^)(UIImage *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1. 利用绘图，建立上下文 BOOL选项为是否为不透明
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        // 2. 设置填充颜色
        if (opaque) {
            [fillColor setFill];
            UIRectFill(rect);
        }
        
        // 3. 利用 贝赛尔路径 `裁切 效果
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [path addClip];
        
        // 4. 绘制图像 如果图片为空那么为单色渲染
        if (self) {
            [self drawInRect:rect];
        }
        
        // 5. 取得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        // 6. 关闭上下文
        UIGraphicsEndImageContext();
        
        //        NSLog(@"%f", CACurrentMediaTime() - start);
        
        // 7. 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
    });
}

//圆角矩形
- (void)gy_roundRectImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor opaque:(BOOL)opaque radius:(CGFloat)radius completion:(void (^)(UIImage *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //        NSTimeInterval start = CACurrentMediaTime();
        
        // 1. 利用绘图，建立上下文 BOOL选项为是否为不透明
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        // 2. 设置填充颜色
        if (opaque) {
            [fillColor setFill];
            UIRectFill(rect);
        }
        
        // 3. 利用 贝赛尔路径 `裁切 效果
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
        //        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [path addClip];
        
        // 4. 绘制图像
        if (self) {
            [self drawInRect:rect];
        }
        
        // 5. 取得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        // 6. 关闭上下文
        UIGraphicsEndImageContext();
        
        //        NSLog(@"%f", CACurrentMediaTime() - start);
        
        // 7. 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
    });
}

@end

#pragma mark - UIImageView
@implementation UIImageView (Extension)
//圆
- (void)gy_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage fillColor:(UIColor *)color{
    [self gy_setCircleImageWithUrlString:urlString placeholder:placeholderImage fillColor:color opaque:color];
}

//网络延迟下载--圆形 背景色为透明 无背景色
- (void)gy_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage{
    [self gy_setCircleImageWithUrlString:urlString placeholder:placeholderImage fillColor:nil opaque:NO];
}

//圆形矩阵
- (void)gy_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage fillColor:(UIColor *)color cornerRadius:(CGFloat) cornerRadius{
    [self gy_setRoundRectImageWithUrlString:urlString placeholder:placeholderImage fillColor:color opaque:color cornerRadius:cornerRadius];
}

//网络延迟下载--圆形矩阵 背景色为透明 无背景色
- (void)gy_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage cornerRadius:(CGFloat) cornerRadius{
    [self gy_setRoundRectImageWithUrlString:urlString placeholder:placeholderImage fillColor:nil opaque:NO cornerRadius:cornerRadius];
}

- (void)gy_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage fillColor:(UIColor *)color opaque:(BOOL)opaque{
    [self.superview layoutIfNeeded];
    NSURL *url = [NSURL URLWithString:urlString];
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (placeholderImage) {
        //占位图片不为空的情况
        //1.现将占位图圆角化，这样就避免了如图片下载失败，使用占位图的时候占位图不是圆角的问题
        [placeholderImage gy_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusPlaceHolder) {
            //2.使用sd的方法缓存异步下载的图片
            [weakSelf sd_setCircleImageWithURL:url placeholderImage:radiusPlaceHolder progressViewType:NPProgressViewTypeCircleSmall completed:^(BOOL isFinished, UIImage *image) {
                if (isFinished) {
                    //3.如果下载成功那么讲下载成功的图进行圆角化
                    [image gy_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusImage) {
                        weakSelf.image = radiusImage;
                    }];
                }
            } animated:NO];
        }];
    } else {
        //占位图片为空的情况
        //2.使用sd的方法缓存异步下载的图片
        [weakSelf sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img gy_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusImage) {
                weakSelf.image = radiusImage;
            }];
        }];
    }
}

- (void)gy_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage fillColor:(UIColor *)color opaque:(BOOL)opaque cornerRadius:(CGFloat) cornerRadius{
    [self.superview layoutIfNeeded];
    NSURL *url = [NSURL URLWithString:urlString];
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (placeholderImage) {
        //占位图片不为空的情况
        //1.现将占位图圆角化，这样就避免了如图片下载失败，使用占位图的时候占位图不是圆角的问题
        [placeholderImage gy_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius completion:^(UIImage *roundRectPlaceHolder) {
            //2.使用sd的方法缓存异步下载的图片
            [weakSelf sd_setCircleImageWithURL:url placeholderImage:roundRectPlaceHolder progressViewType:NPProgressViewTypeCircleSmall completed:^(BOOL isFinished, UIImage *image) {
                if (isFinished) {
                    //3.如果下载成功那么讲下载成功的图进行圆角化
                    [image gy_roundRectImageWithSize:image.size fillColor:color opaque:opaque radius:((image.size.height/size.height)*cornerRadius) completion:^(UIImage *radiusImage) {
                        weakSelf.image = radiusImage;
                    }];
                }
            } animated:NO];
        }];
    } else {
        //占位图片为空的情况
        //.使用sd的方法缓存异步下载的图片
        [weakSelf sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img gy_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius completion:^(UIImage *radiusImage) {
                weakSelf.image = radiusImage;
            }];
        }];
    }
}

@end

#pragma mark - UIButton
@implementation UIButton (Extension)
//圆形
- (void)gy_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage fillColor:(UIColor *)color forState:(UIControlState)state {
    [self gy_setCircleImageWithUrlString:urlString placeholder:placeholderImage fillColor:color opaque:color forState:state];
}

//button--圆形    背景为透明 无背景色
- (void)gy_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage forState:(UIControlState)state{
    [self gy_setCircleImageWithUrlString:urlString placeholder:placeholderImage fillColor:nil opaque:NO forState:state];
}

//圆角矩阵
- (void)gy_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage fillColor:(UIColor *)color cornerRadius:(CGFloat) cornerRadius forState:(UIControlState)state{
    
    [self gy_setRoundRectImageWithUrlString:urlString placeholder:placeholderImage fillColor:color opaque:color cornerRadius:cornerRadius forState:state];
}

//button--圆角矩形 背景为透明 无背景色
- (void)gy_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage cornerRadius:(CGFloat) cornerRadius forState:(UIControlState)state{
    [self gy_setRoundRectImageWithUrlString:urlString placeholder:placeholderImage fillColor:nil opaque:NO cornerRadius:cornerRadius forState:state];
}

- (void)np_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder radius:(CGFloat)radius fillColor:(UIColor *)fillColor{
    {
        __weak typeof(self) wself = self;
        [self sd_setImageWithURL:url forState:state placeholderImage:placeholder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //3.如果下载成功那么讲下载成功的图进行圆角化
            if (error) {
                [placeholder gy_roundRectImageWithSize:wself.frame.size fillColor:fillColor opaque:YES radius:radius completion:^(UIImage *roundRectImage) {
                    [wself setImage:roundRectImage forState:state];
                }];
            }else{
                [img gy_roundRectImageWithSize:wself.frame.size fillColor:fillColor opaque:YES radius:radius completion:^(UIImage *roundRectImage) {
                    [wself setImage:roundRectImage forState:state];
                }];
            }
        }];
    }
}
- (void)gy_setRoundRectImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage fillColor:(UIColor *)color opaque:(BOOL)opaque cornerRadius:(CGFloat) cornerRadius forState:(UIControlState)state{
    NSURL *url = [NSURL URLWithString:urlString];
    [self.superview layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (placeholderImage) {
        //占位图片不为空的情况
        //占位处理
        [placeholderImage gy_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius completion:^(UIImage *roundRectPlaceHolder) {
            //sd
            [weakSelf sd_setImageWithURL:url forState:state placeholderImage:roundRectPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //3.如果下载成功那么讲下载成功的图进行圆角化
                [img gy_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius completion:^(UIImage *roundRectImage) {
                    [weakSelf setImage:roundRectImage forState:state];
                }];
                
            }];
            
        }];
    } else {
        //占位图片为空的情况
        [weakSelf sd_setImageWithURL:url forState:state placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img gy_roundRectImageWithSize:size fillColor:color opaque:opaque radius:cornerRadius completion:^(UIImage *roundRectImage) {
                [weakSelf setImage:roundRectImage forState:state];
            }];
            
        }];
    }
}

- (void)gy_setCircleImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholderImage fillColor:(UIColor *)color opaque:(BOOL)opaque forState:(UIControlState)state{
    NSURL *url = [NSURL URLWithString:urlString];
    [self.superview layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    CGSize size = self.frame.size;
    
    if (placeholderImage) {
        //占位图片不为空的情况
        //占位处理
        [placeholderImage gy_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusPlaceHolder) {
            //sd
            [weakSelf sd_setImageWithURL:url forState:state placeholderImage:radiusPlaceHolder completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //3.如果下载成功那么讲下载成功的图进行圆角化
                [img gy_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusImage) {
                    [weakSelf setImage:radiusImage forState:state];
                }];
                
            }];
            
        }];
    } else {
        //占位图片为空的情况
        [weakSelf sd_setImageWithURL:url forState:state placeholderImage:nil completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //3.如果下载成功那么讲下载成功的图进行圆角化
            [img gy_roundImageWithSize:size fillColor:color opaque:opaque completion:^(UIImage *radiusImage) {
                [weakSelf setImage:radiusImage forState:state];
            }];
            
        }];
    }
    
}
@end
