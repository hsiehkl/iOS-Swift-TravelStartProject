//
//  PhotoCell.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    static let cellId = "PhotoCell"
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with imageUrl: String) {
        photoImageView.image = nil
        photoImageView.setImage(with: imageUrl)
    }

}
