//
//  FrameViewController.m
//  Demo
//
//  Created by lx13417 on 2017/9/4.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import "FrameViewController.h"
#import "FDFeedEntity.h"
#import "FrameModel.h"
#import "FrameFeedCell.h"
#import <MJRefresh.h>

@interface FrameViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvFeed;

@property (strong, nonatomic) NSMutableArray <FrameModel *> *data;

@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;
@end

@implementation FrameViewController

- (void)dealloc {
    NSLog(@"%@ - dealloc",self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTestDataThen:^(NSMutableArray <FDFeedEntity *> *entities) {
        self.data = @[].mutableCopy;
        @autoreleasepool {
            for (FDFeedEntity *entity in entities) {
                FrameModel *frameModel = [FrameModel new];
                frameModel.entity = entity;
                [self.data addObject:frameModel];
            }
        }
        [self.tvFeed reloadData];
    }];
    
    [self.tvFeed registerClass:[FrameFeedCell class] forCellReuseIdentifier:FrameFeedCellIdentifier];
    
    __weak typeof(self) weakSelf = self;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.data addObjectsFromArray:weakSelf.data];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.footer endRefreshing];
            [weakSelf.tvFeed reloadData];
        });
    }];
    
    self.tvFeed.mj_footer = _footer;

}

- (void)buildTestDataThen:(void (^)(NSMutableArray *entities))then {
    // Simulate an async request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Data from `data.json`
        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *feedDicts = rootDict[@"feed"];
        
        // Convert to `FDFeedEntity`
        NSMutableArray *entities = @[].mutableCopy;
        [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:[[FDFeedEntity alloc] initWithDictionary:obj]];
        }];
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            !then ?: then(entities);
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FrameFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:FrameFeedCellIdentifier forIndexPath:indexPath];
    FrameModel *frameModel = self.data[indexPath.row];
    cell.model = frameModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FrameModel *frameModel = self.data[indexPath.row];
    return frameModel.cellHeight;
}

@end
