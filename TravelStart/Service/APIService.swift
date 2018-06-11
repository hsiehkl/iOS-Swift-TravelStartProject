//
//  APIService.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import Foundation
import Alamofire


typealias FetchTouristSitesResult = ( _ success: Bool, _ touristSites: [TouristSite]?, _ error: Error?, _ totalPages: Int?) -> Void

protocol APIServiceProtocol: class {
    func fetchTouristSites(limit: Int?, offset: Int?, completion: @escaping FetchTouristSitesResult)
}

class APIService: APIServiceProtocol {
    
     func fetchTouristSites(limit: Int?, offset: Int?, completion: @escaping FetchTouristSitesResult) {
        let limitData = limit ?? 0
        let offsetData = offset ?? 0
        let url = String(
            format:"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=36847f3f-deff-4183-a5bb-800737591de5&limit=%d&offset=%d", limitData, offsetData)
        
        
        Alamofire.request(url, method: .get, parameters: [:]).responseJSON { response in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard response.error == nil,
                let json = response.data,
                let jsonData = try? decoder.decode(TouristSiteJSONData.self, from: json)
            else {
                completion(false, nil, response.error, nil)
                return
            }
            let totalPages = (limitData == 0) ? 0 : ceil(Double(jsonData.result.count) / Double(limitData))
            completion(true, jsonData.result.results, nil, Int(totalPages))
        }
    }
    
}

// Mock
extension APIService {
    func mockFetchTouristSitesWithWrongUrl(limit: Int?, offset: Int?, completion: @escaping FetchTouristSitesResult) {
        let limitData = limit ?? 0
        let offsetData = offset ?? 0
        let imcompletedUrl = String(
            format:"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid", limitData, offsetData)
        
        Alamofire.request(imcompletedUrl, method: .get, parameters: [:]).responseJSON { response in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            guard response.error == nil,
                let json = response.data,
                let jsonData = try? decoder.decode(TouristSiteJSONData.self, from: json)
                else {
                    completion(false, nil, response.error, nil)
                    return
            }
            let totalPages = (limitData == 0) ? 0 : ceil(Double(jsonData.result.count) / Double(limitData))
            completion(true, jsonData.result.results, nil, Int(totalPages))
        }
    }

}
