//
//  TouristSiteCell.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import UIKit
import SDWebImage

class TouristSiteCell: UITableViewCell {

    static let cellId = "TouristSiteCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    private var imageUrls = [String]()
    var touristSiteListViewController: TouristSiteListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.sizeToFit()
    }
    
    func setupViews() {
        contentView.backgroundColor = UIColor.Theme.touristSitesTableViewGray
        selectionStyle = .none
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.showsHorizontalScrollIndicator = false
        let nib = UINib(nibName: PhotoCell.cellId, bundle: nil)
        photoCollectionView.register(nib, forCellWithReuseIdentifier: PhotoCell.cellId)
    }
    
    func configureCell(with touristStie: TouristSiteListCellViewModel, touristSiteListViewController: TouristSiteListViewController) {
        titleLabel.text = touristStie.title ?? "No title"
        descriptionLabel.text = touristStie.description ?? "No description"
        self.touristSiteListViewController = touristSiteListViewController
        guard let urls = touristStie.imageUrls else { return }
        self.imageUrls = urls
        let id = touristStie.id ?? "-1"
        let idInt = Int(id) ?? -1
        self.photoCollectionView.tag = idInt
        self.photoCollectionView.reloadData()
    }
}

extension TouristSiteCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = height * 4 / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellId, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        if imageUrls.count > indexPath.row {
            let url = imageUrls[indexPath.row]
            cell.configureCell(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        touristSiteListViewController?.goToDetailPage(with: "\(collectionView.tag)")
    }
}
