# 带视差效果的轮播实现思路

我们先来看看效果：

![](http://p0kmbfoc8.bkt.clouddn.com/6666.gif)

看起来高富帅了不少。其实几行代码就搞定了，我们获取当前在屏幕上的 cell，计算相对移动的距离，然后，把 cell 本身的 imageView 向相反方向按照一定的速度来移动：

```swift
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        cvParallex.visibleCells.forEach { (bannerCell) in
            handleEffect(cell: bannerCell as! ItemPic)
        }
    }
    
    private func handleEffect(cell: ItemPic){
        let minusX = cvParallex.contentOffset.x - cell.frame.origin.x
        let imageOffsetX = (-minusX) * 0.5;
        cell.scrollView.contentOffset = CGPoint(x: imageOffsetX, y: 0)
    }
}
```

要注意的是，需要为每个图片添加个 `UIScrollView` 父控件。至于怎么为 `UIScrollView` 的子控件添加约束，可以看看这篇文章 [iOS 之 UIScrollview 添加约束图文详解](https://www.jianshu.com/p/e4a12061776d)。


