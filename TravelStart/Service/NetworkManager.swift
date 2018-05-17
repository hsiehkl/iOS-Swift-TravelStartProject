//
//  NetworkManager.swift
//  TravelStart
//
//  Created by HsiaoAi on 2018/5/16.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager {
    var reachability: Reachability!
    static let shared = NetworkManager()

    private init() {
        
        reachability = Reachability()!
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func stopNotifier() -> Void {
       self.reachability.stopNotifier()
    }
    
    func isReachable(completion: @escaping (_ networkManger: NetworkManager, _ isReachable: Bool) -> Void) {
        let isReachable: Bool = self.reachability.connection != .none
        completion(self, isReachable)
    }
    
    func isReachableViaWifi(completion: @escaping (_ networkManger: NetworkManager, _ isReachableViaWifi: Bool) -> Void) {
        let isReachableViaWifi: Bool = self.reachability.connection == .none
        completion(self, isReachableViaWifi)
    }
    
    func isReachableViaWWAN(completion: @escaping (_ networkManger: NetworkManager, _ isReachableViaWWAN: Bool) -> Void) {
        let isReachableViaWWAN: Bool = self.reachability.connection == .cellular
        completion(self, isReachableViaWWAN)
    }
    
    
}

extension NetworkManager {
    @objc func networkStatusChanged() {
        if self.reachability.connection == .none {
            NotificationCenter.default.post(name: .noConnection, object: nil)
        } 
    }
}
