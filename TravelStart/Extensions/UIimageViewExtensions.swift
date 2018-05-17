//
//  UIimageViewExtensions.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/16.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(with imageUrl: String) {
        self.sd_setImage(
            with: URL(string: imageUrl),
            placeholderImage: #imageLiteral(resourceName: "imagePlaceholder"),
            options: SDWebImageOptions.forceTransition,
            completed: {image, _, _, url in
                DispatchQueue.main.async {
                    self.contentMode = .scaleAspectFill
                    if image == nil {
                        self.image = #imageLiteral(resourceName: "imageNotAvaiable")
                    }
                }
        })
    }
}
