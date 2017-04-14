//
//  MyFlowLayout.m
//  HorizontalCollectionView
//
//  Created by lx13417 on 2017/4/12.
//  Copyright © 2017年 lx13417. All rights reserved.
//

#define PageTotalCount 12.0f
#define PageTotalRow 3  //行
#define PageTotalCol 4  //列
#define ItemHeight 80.0f

#import "MyFlowLayout.h"

@implementation MyFlowLayout {
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *_attributesArr;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    //提前缓存好各个 item frame
    
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    NSInteger item = [self.collectionView numberOfItemsInSection:0];
    CGFloat width = [UIScreen mainScreen].bounds.size.width / PageTotalCol;
    
    for (int i = 0; i < item; i++) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        CGRect frame = attributes.frame;
        
        int x = i/PageTotalCount;
        frame.origin.x = (x*self.collectionView.bounds.size.width) + (i%PageTotalCol)*width;
        
        int y = i/PageTotalCol;
        frame.origin.y = (y%PageTotalRow)*ItemHeight;
        
        frame.size = CGSizeMake(width, ItemHeight);
        
        attributes.frame = frame;
        [_attributesArr addObject:attributes];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attributesArr;
}

- (CGSize)collectionViewContentSize {
    //计算好 ContentSize
    NSInteger item = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(ceil(item/PageTotalCount)*self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}
@end
