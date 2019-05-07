//
//  GYSectorProgressView.h
//  GYWebImage
//
//  Created by lyons on 2017/11/10.
//  Copyright © 2017年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYSectorProgressView : UIView
/**
 *  初始化，只需传入view的center即可
 */
- (instancetype)initWithCenter:(CGPoint)center;
/**
 *  进度值0-1.0之间
 */
@property (nonatomic,assign)CGFloat progressValue;

/**
 *  扇形颜色
 */
@property(nonatomic,strong)UIColor *progressColor;
@end
