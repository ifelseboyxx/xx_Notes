//
//  ViewController.swift
//  ParallexDemo
//
//  Created by lx13417 on 2018/1/9.
//  Copyright © 2018年 ifelseboyxx. All rights reserved.
//

import UIKit

private let ItemPicIdentifier = "ItemPic"

class ViewController: UIViewController {
    
    @IBOutlet weak var cvParallex: UICollectionView!
    
    let datas = [UIImage.init(named: "p0.jpg"),UIImage.init(named: "p1.jpg"),UIImage.init(named: "p2.jpg")]
        override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvParallex.register(UINib.init(nibName: NSStringFromClass(ItemPic.self).components(separatedBy: ".").last!, bundle: nil), forCellWithReuseIdentifier: ItemPicIdentifier);
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemPicIdentifier, for: indexPath) as! ItemPic
        cell.image = datas[indexPath.row]!
        return cell
    }
}

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

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 200)
    }
}
