//
//  ViewController.m
//  HorizontalCollectionView
//
//  Created by lx13417 on 2017/4/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#import "ViewController.h"

static NSString *const kMyCollectionViewItemIdentifier = @"MyCollectionViewItem";

@interface MyCollectionViewItem : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

/** item */
@property (assign, nonatomic) NSInteger index;

@end


@implementation MyCollectionViewItem

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.icon.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}


- (void)setIndex:(NSInteger)index {
    _index = index;
    
    self.lblTitle.text = [NSString stringWithFormat:@"第%@个",@(index)];
    
}
@end


@interface ViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *cvItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.cvItem registerNib:[UINib nibWithNibName:kMyCollectionViewItemIdentifier bundle:nil] forCellWithReuseIdentifier:kMyCollectionViewItemIdentifier];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 22;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyCollectionViewItemIdentifier forIndexPath:indexPath];
    cell.index = indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"第%@个",@(indexPath.item)] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}
@end
