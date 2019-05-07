//
//  GYViewController.m
//  GYWebImage
//
//  Created by lyons on 2019/5/6.
//  Copyright © 2019 GY. All rights reserved.
//

#import "GYViewController.h"
#import "GYDetailViewController.h"
#import <SDWebImage/SDImageCache.h>
#define CellReuseIdentifier @"CellReuseIdentifier"
@interface GYViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation GYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self setTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}
- (void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYDetailViewController *vc = [GYDetailViewController new];
    vc.title = self.array[indexPath.row][@"title"];
    [self.navigationController pushViewController:vc animated:true];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    cell.textLabel.text = self.array[indexPath.row][@"title"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray arrayWithArray:@[@{@"title":@"圆形加载"}]];
    }
    return _array;
}
@end
