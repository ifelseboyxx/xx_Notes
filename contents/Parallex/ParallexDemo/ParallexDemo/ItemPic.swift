//
//  ItemPic.swift
//  ParallexDemo
//
//  Created by lx13417 on 2018/1/9.
//  Copyright © 2018年 ifelseboyxx. All rights reserved.
//

import UIKit

class ItemPic: UICollectionViewCell {

    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage! {
        willSet {
            pic.image = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
