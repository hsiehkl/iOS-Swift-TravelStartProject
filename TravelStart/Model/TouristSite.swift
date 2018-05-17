//
//  TouristSite.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/15.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

struct TouristSite: Codable {
    
    var _id: String?
    var RowNumber: String?
    var REF_WP: String?
    var CAT1: String?
    var CAT2: String?
    var SERIAL_NO: String?
    var MEMO_TIME: String?
    var stitle: String?
    var xbody: String?
    var avBegin: String?
    var avEnd: String?
    var idpt: String?
    var address: String?
    var xpostDate: String?
    var file: String?
    var langinfo: String?
    var POI: String?
    var info: String?
    var longitude: String?
    var latitude: String?
    var MRT: String?
    
    var dictionary: [String: Any] {
        return [
            "_id": _id ?? "",
            "RowNumber": RowNumber ?? "",
            "REF_WP": REF_WP ?? "",
            "CAT1": CAT1 ?? "",
            "CAT2": CAT2 ?? "",
            "SERIAL_NO": SERIAL_NO ?? "",
            "MEMO_TIME": MEMO_TIME ?? "",
            "stitle": stitle ?? "",
            "xbody": xbody ?? "",
            "avBegin": avBegin ?? "",
            "avEnd": avEnd ?? "",
            "idpt": idpt ?? "",
            "address": address ?? "",
            "xpostDate": xpostDate ?? "",
            "file": file ?? "",
            "langinfo": langinfo ?? "",
            "POI": POI ?? "",
            "info": info ?? "",
            "longitude": longitude ?? "",
            "latitude": latitude ?? "",
            "MRT": MRT ?? "",
        ]
    }
    
    var imageUrls: [String]? {
        guard let urls = self.file else { return nil }
        let urlsArray = urls.lowercased().components(separatedBy: ".jpg").filter { $0 != ""}.map { $0 + ".jpg" }
        return urlsArray
    }
    
}
    
struct TouristSiteJSONData: Codable {
    var result: Meteorological
    
    struct Meteorological: Codable {
        var offset: Double
        var limit: Double
        var count: Double
        var sort: String
        var results: [TouristSite]
    }
}





