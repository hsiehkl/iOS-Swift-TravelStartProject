//
//  TouristSiteListViewController.swift
//  TouristSiteListViewController
//
//  Created by HsiaoAi on 2018/5/14.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import UIKit
import SVProgressHUD
import Foundation

class TouristSiteListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var reloadButton: UIButton!
    let reachability = NetworkManager.shared
    
    lazy var viewModel: TouristSiteListViewModel = {
       return TouristSiteListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNoConnectionView()
        setupViewModel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineAlert), name: .noConnection, object: nil)
        
        tableView.accessibilityIdentifier = "touristStieListTableViewIdentifier"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideTitle()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupTableView() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = UIColor.Theme.touristSitesTableViewGray
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: TouristSiteCell.cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TouristSiteCell.cellId)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
    }
    
    func setupNoConnectionView() {
        noConnectionView.alpha = 0
        reloadButton.layer.cornerRadius = 10
        reloadButton.clipsToBounds = true
        reloadButton.addTarget(self, action: #selector(reConnectInternet), for: .touchUpInside)
    }
    
    func setupViewModel() {
        
        viewModel.showNoConnectionView = { [weak self] isShow in
            self?.hideNoConnectionView(isHidden: !isShow)
            if isShow {
                self?.showOfflineAlert()
            }
        }
        
        viewModel.reloadTableViewClosure = {[weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if let offset = self?.viewModel.offset {
                    let indexPath = IndexPath(row: offset, section: 0)
                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        
        viewModel.showAlertClosure = { [weak self] () in
            if let message = self?.viewModel.alertMessage {
                self?.showAlert(with: message)
            }
        }

        viewModel.updateLoadingStatus = {[weak self] () in
            let isLoading = self?.viewModel.isLoading ?? false
            if isLoading {
                self?.showProgress(with: "Loading")
            } else {
                self?.dismissProgress()
            }
        }
        
        viewModel.checkInternetCompletion = {[weak self] isReachable in
            if isReachable {
                self?.viewModel.fetchData()
            } 
        }
        
        viewModel.checkInternetConnection()
    }
    
    func setupTitle() {
        self.title = viewModel.title
    }
    
    func hideTitle() {
        self.title = ""
    }

    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showProgress(with status: String) {
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: status)
        }
    }
    
    private func dismissProgress() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    @objc func showOfflineAlert() -> Void {
        self.hideNoConnectionView(isHidden: false)
        let alertViewController = UIAlertController(title: "Error", message: "You're offline, please connect to the internet", preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _  in self.reConnectInternet()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in
        })
        alertViewController.addAction(retryAction)
        alertViewController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.reachability.isReachable { (_, isReachable) in
                if !isReachable {
                    self.present(alertViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func hideNoConnectionView(isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.noConnectionView.alpha = alpha
            })
        }
    }
}


extension TouristSiteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TouristSiteCell.cellId) as? TouristSiteCell else {
            return UITableViewCell()
        }
        
        guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell") as? LoadingCell else { return UITableViewCell() }
        
        if self.viewModel.cellViewModels.count > indexPath.row {
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            cell.configureCell(with: cellViewModel, touristSiteListViewController: self)
            return cell
        } else {
            return loadingCell
        }        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for cell in tableView.visibleCells {
            if cell.reuseIdentifier == "LoadingCell",
                let loadingCell = cell as? LoadingCell {
                loadingCell.activityIndicator.startAnimating()
                viewModel.fetchData()
                return
            }
        }
    }

}

extension TouristSiteListViewController {
    func goToDetailPage(with id: String) {
        var index = -1
        for (cellViewModelIndex, cellViewModel) in viewModel.cellViewModels.enumerated() {
            if cellViewModel.id == id {
                index = cellViewModelIndex
                break
            }
        }
        guard index != -1 else { return }
        let touristSiteDetailStoryboard = UIStoryboard(name: "TouristSiteDetail", bundle: nil)
        
        guard let touristSiteDetailViewController = touristSiteDetailStoryboard.instantiateViewController(withIdentifier: "TouristSiteDetailViewController") as? TouristSiteDetailViewController
            else { return }
        
        touristSiteDetailViewController.viewModel = TouristSiteDetailViewModel(touristSite: viewModel.touristSites[index])
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(touristSiteDetailViewController, animated: true)
        }
    }
    
    @objc func reConnectInternet() {
        viewModel.checkInternetConnection()
    }
    
}


