//
//  ViewController.m
//  ProtocolDemo
//
//  Created by Jason on 2017/4/16.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "ViewController.h"
#import "MyDetialViewController.h"

static NSString *const kUITableViewCellIdentifier = @"UITableViewCell";

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvList;

/** data list */
@property (strong, nonatomic) NSArray <NSDictionary *> *dataArr;

@end

@implementation ViewController

- (NSArray<NSDictionary *> *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@{@"projectTag" : @"A"},
                     @{@"projectTag" : @"B"}];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tvList registerClass:[UITableViewCell class] forCellReuseIdentifier:kUITableViewCellIdentifier];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row][@"projectTag"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyDetialViewController *detialVC = [[MyDetialViewController alloc] initWithNibName:@"MyDetialViewController" bundle:nil];
    detialVC.projectTag = self.dataArr[indexPath.row][@"projectTag"];
    [self.navigationController pushViewController:detialVC animated:YES];
}


@end
