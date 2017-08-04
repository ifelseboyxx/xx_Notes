//
//  TestTableViewCell.m
//  ResponderChainDemo
//
//  Created by lx13417 on 2017/8/3.
//  Copyright © 2017年 ifelseboyxx. All rights reserved.
//

#import "TestTableViewCell.h"
#import "TestTestTableViewCell.h"
#import "UIResponder+Router.h"

NSString * const TestTableViewCellIdentifier = @"TestTableViewCell";

@interface TestTableViewCell ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UITableView *tvList;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeightConstraint;


@end

@implementation TestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.tvList registerNib:[UINib nibWithNibName:TestTestTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:TestTestTableViewCellIdentifier];
}


- (void)setDict:(NSDictionary<NSString *,NSString *> *)dict {
    _dict = dict;
    
    self.lblTitle.text = dict[@"test"];
    
    [self.tvList reloadData];
    self.tvHeightConstraint.constant = self.tvList.contentSize.height;
 
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dict[@"arr"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TestTestTableViewCellIdentifier forIndexPath:indexPath];
    NSArray *arr = self.dict[@"arr"];
    cell.subTitle = arr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self routerEventWithSelectorName:@"cell:userInfo:" object:self userInfo:@{@"key":indexPath}];
}

- (void)routerEventWithSelectorName:(NSString *)selectorName object:(id)object userInfo:(NSDictionary *)userInfo {
    
    NSMutableDictionary *mDict = [userInfo mutableCopy];
    mDict[@"test"] = @"测试";

    [super routerEventWithSelectorName:selectorName object:object userInfo:[mDict copy]];
}
@end
