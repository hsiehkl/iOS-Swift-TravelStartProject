//
//  TouristSiteDetailViewModel.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/16.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import Foundation

class TouristSiteDetailViewModel {
    let touristSite: TouristSite
    let detailComponents: [TouristStieDetailType] = [.title, .description, .information, .timeMemo, .address]
    
    var numberOfCells: Int {
        return self.detailComponents.count
    }
    
    init(touristSite: TouristSite) {
        self.touristSite = touristSite
    }
}

enum TouristStieDetailType {
    
    case title, description, address, information, timeMemo
    
    var title: String {
        switch self {
        case .title:
            return "景點名稱"
        case .description:
            return "景點介紹"
        case .address:
            return "景點地址"
        case .information:
            return "景點資訊"
        case .timeMemo:
            return "營業時間"
        }
    }
    
}
