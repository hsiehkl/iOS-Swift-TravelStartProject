//
//  TouristSiteDetailViewController.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class TouristSiteDetailViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.tintColor = UIColor.black.withAlphaComponent(0.4)
            pageControl.currentPageIndicatorTintColor = .black
        }
    }
    var viewModel: TouristSiteDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViews()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.contentOffset = .zero
        collectionView.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    func setupViews() {
        self.navigationItem.title = viewModel.touristSite.stitle
        pageControl.numberOfPages = viewModel.touristSite.imageUrls?.count ?? 0
    }
    
    func setupTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: TouristSiteDetailCell.cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TouristSiteDetailCell.cellId)
    }
    
}

extension TouristSiteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TouristSiteDetailCell.cellId) as? TouristSiteDetailCell else {
            return UITableViewCell()
        }
        let component = viewModel.detailComponents[indexPath.row]
        var content = ""
        switch component {
        case .title:
            content = viewModel.touristSite.stitle ?? "No title"
        case .description:
            content = viewModel.touristSite.xbody ?? "No description"
        case .timeMemo:
            content = viewModel.touristSite.MEMO_TIME ?? "No time memo"
        case .address:
            content = viewModel.touristSite.address ?? "No address"
        case .information:
            content = viewModel.touristSite.info ?? "No information"
        }
        cell.contentLabel.text = content
        cell.titleLabel.text = component.title
        return cell
    }
}

extension TouristSiteDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.touristSite.imageUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionCell.cellId, for: indexPath) as? PhotoListCollectionCell else { return UICollectionViewCell() }
        
        if let imageUrls = viewModel.touristSite.imageUrls,
            imageUrls.count > indexPath.row {
            let url = imageUrls[indexPath.row]
            cell.photoImageView.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / collectionView.bounds.width)
        pageControl.currentPage = index
    }
}

class PhotoListCollectionCell: UICollectionViewCell {
    static let cellId = "PhotoListCollectionCell"
    @IBOutlet weak var photoImageView: UIImageView!
}




