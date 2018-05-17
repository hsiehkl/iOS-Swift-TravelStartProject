//
//  TouristSiteDetailCell.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import UIKit

class TouristSiteDetailCell: UITableViewCell {

    static let cellId = "TouristSiteDetailCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.sizeToFit()
    }
    
    func setupViews() {
        selectionStyle = .none
    }
    
}


