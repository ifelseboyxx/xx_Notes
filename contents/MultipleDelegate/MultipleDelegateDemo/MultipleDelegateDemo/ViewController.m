//
//  ViewController.m
//  MultipleDelegateDemo
//
//  Created by lx13417 on 2017/4/11.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "ViewController.h"
#import "XXViewOne.h"
#import "XXViewTwo.h"
#import "MultipleDelegateHelper.h"


static NSString *const kUITableViewCellIdentifier = @"UITableViewCell";

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvList;

/** strong helper */
@property (strong, nonatomic) MultipleDelegateHelper *helper;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tvList registerClass:[UITableViewCell class]
        forCellReuseIdentifier:kUITableViewCellIdentifier];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    XXViewOne *viewOne = [XXViewOne setUp];
    viewOne.frame = (CGRect){10.0f,84.0f,(screenWidth - 30.0f)/2.0f,180.0f};
    [self.view addSubview:viewOne];
    
    XXViewTwo *viewTwo = [XXViewTwo setUp];
    viewTwo.frame = (CGRect){CGRectGetMaxX(viewOne.frame) + 10.0f,84.0f,(screenWidth - 30.0f)/2.0f,180.0f};
    [self.view addSubview:viewTwo];
    
    MultipleDelegateHelper *helper = [MultipleDelegateHelper new];
    helper.delegateTargets = @[self,viewOne,viewTwo];
    self.helper = helper;
    self.tvList.dataSource = (id<UITableViewDataSource>)helper;
    self.tvList.delegate = (id<UITableViewDelegate>)helper;
}

#pragma mark- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [@(indexPath.row) stringValue];
    return cell;
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}
@end
