//
//  XXViewTwo.m
//  MultipleDelegateDemo
//
//  Created by lx13417 on 2017/4/11.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "XXViewTwo.h"

@interface XXViewTwo ()
<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTwo;

@end

@implementation XXViewTwo

+ (instancetype)setUp {
    return [[NSBundle mainBundle] loadNibNamed:@"XXViewTwo" owner:self options:nil].firstObject;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.lblTwo.text = [NSString stringWithFormat:@"%.01f",scrollView.contentOffset.y];
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

@end
