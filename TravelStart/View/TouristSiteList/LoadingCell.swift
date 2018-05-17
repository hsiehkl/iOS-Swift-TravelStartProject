//
//  LoadingCell.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    var activityIndicator: UIActivityIndicatorView!
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor.Theme.touristSitesTableViewGray
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.activityIndicatorViewStyle = .gray
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        contentView.addSubview(indicator)

        indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        activityIndicator = indicator
    }
}
