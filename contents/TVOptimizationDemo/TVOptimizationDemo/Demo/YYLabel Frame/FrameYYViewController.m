//
//  FrameYYViewController.m
//  Demo
//
//  Created by lx13417 on 2017/9/5.
//  Copyright © 2017年 forkingdog. All rights reserved.
//

#import "FrameYYViewController.h"
#import "FDFeedEntity.h"
#import "FrameYYModel.h"
#import "FrameYYFeedCell.h"
#import <MJRefresh.h>

@interface FrameYYViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvList;

@property (strong, nonatomic) NSMutableArray <FrameYYModel *> *data;

@property (strong, nonatomic) MJRefreshAutoNormalFooter *footer;
@end

@implementation FrameYYViewController

- (void)dealloc {
    NSLog(@"%@ - dealloc",self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTestDataThen:^(NSMutableArray *entities) {
        self.data = @[].mutableCopy;
        
        @autoreleasepool {
            for (FDFeedEntity *entity in entities) {
                FrameYYModel *frameModel = [FrameYYModel new];
                frameModel.entity = entity;
                [self.data addObject:frameModel];
            }
            
            
        }
        
        [self.tvList reloadData];
    }];
    
    [self.tvList registerClass:[FrameYYFeedCell class] forCellReuseIdentifier:FrameYYFeedCellIdentifier];
    
    __weak typeof(self) weakSelf = self;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.data addObjectsFromArray:weakSelf.data];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.footer endRefreshing];
            [weakSelf.tvList reloadData];
        });
        
    }];
    
    self.tvList.mj_footer = _footer;
    
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
    FrameYYFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:FrameYYFeedCellIdentifier forIndexPath:indexPath];
    cell.model = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.data[indexPath.row].cellHeight;
}

- (IBAction)reload:(UIBarButtonItem *)sender {
    
    [self.tvList reloadData];
    
}

@end
