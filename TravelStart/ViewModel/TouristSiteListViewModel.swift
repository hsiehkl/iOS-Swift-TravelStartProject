//
//  TouristSiteListViewModel.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//
import UIKit

class TouristSiteListViewModel {
    
    let apiService: APIServiceProtocol
    private let network: NetworkManager = NetworkManager.shared

    private let limit = 10
    private var currentPage = 0
    private var totalPages = 0
    var offset: Int = 0
    var touristSites: [TouristSite] = [TouristSite]()
    
    var cellViewModels: [TouristSiteListCellViewModel] = [TouristSiteListCellViewModel]() {
        didSet {
            self.isInitFetchData = cellViewModels.count == 0
            self.reloadTableViewClosure?()
        }
    }

    
    let title = "台北市熱門景點"
    private var isInitFetchData: Bool = true
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var isShowNoConnectionView: Bool = false {
        didSet {
            self.showNoConnectionView?(isShowNoConnectionView)
        }
    }
    
    var shouldShowLoadingCell: Bool = false
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return shouldShowLoadingCell ? cellViewModels.count + 1 : cellViewModels.count
    }
    
    var reloadTableViewClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var showNoConnectionView: ((_ isshow: Bool) -> Void)?
    var checkInternetCompletion: ((_ isReachable: Bool) -> Void)?
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    @objc func checkInternetConnection() {
        self.network.isReachable { (_ , isReachable) in
            if isReachable {
                self.checkInternetCompletion?(true)
            } else {
                self.isShowNoConnectionView = true
            }
        }
    }
    
    func fetchData() {
        if isInitFetchData {
            self.isLoading = true
        }
        self.offset = self.touristSites.count
        apiService.fetchTouristSites(limit: self.limit, offset: self.offset) { [weak self] (success, touristSites, error, totalPages) in
            self?.isLoading = false
            self?.isShowNoConnectionView = !success
            if let error = error {
                self?.alertMessage = error.localizedDescription
            } else if let touristSites = touristSites {
                self?.processFetchTouristSites(touristSites: touristSites, totalPages: totalPages)
            }
        }
    }
    
    
    private func processFetchTouristSites(touristSites: [TouristSite], totalPages: Int?) {
        self.touristSites.append(contentsOf: touristSites)
        var newCellViewModels = [TouristSiteListCellViewModel]()
        for touristSite in touristSites {
            let cellViewModel = createCellViewModel(touristSite: touristSite)
            newCellViewModels.append(cellViewModel)
        }
        self.currentPage = Int(ceil(Double(self.cellViewModels.count) / 10.0))
        self.totalPages = totalPages ?? 0
        self.shouldShowLoadingCell = self.totalPages > self.currentPage
        self.cellViewModels.append(contentsOf: newCellViewModels)
    }
    
    
    
    func createCellViewModel(touristSite: TouristSite) -> TouristSiteListCellViewModel {
        let title = touristSite.stitle
        let description = touristSite.xbody 
        let imageUrls = touristSite.imageUrls
        let id = touristSite._id
        return TouristSiteListCellViewModel(id: id, imageUrls: imageUrls,
                                            title: title,
                                            description: description)
    }
}

