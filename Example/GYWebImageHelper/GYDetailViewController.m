//
//  GYDetailViewController.m
//  GYWebImage
//
//  Created by lyons on 2019/5/6.
//  Copyright © 2019 GY. All rights reserved.
//

#import "GYDetailViewController.h"
#import "UIImageView+GYProgressView.h"
@interface GYDetailViewController ()

@end

@implementation GYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView sd_setCircleImageWithURL:[NSURL URLWithString:@"https://img.ivsky.com/img/tupian/pre/201810/18/xiliu-004.jpg"] placeholderImage:[UIImage imageNamed:@""] animated:true];
}

@end
