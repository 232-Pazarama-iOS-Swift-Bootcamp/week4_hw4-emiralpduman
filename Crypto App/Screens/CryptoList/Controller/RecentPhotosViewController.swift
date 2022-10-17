//
//  RecentPhotosViewController.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 8.10.2022.
//

import UIKit
import Kingfisher

final class RecentPhotosViewController: FAViewController  {
    private var viewModel: RecentPhotosViewModel
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Init
    init(viewModel: RecentPhotosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recent"
        let tabBarIcon = Asset.home.image
        tabBarItem = UITabBarItem(title: "Recent",
                                  image: tabBarIcon,
                                  tag: .zero)
        
        tabBarController?.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "RecentsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        viewModel.fetchPhotos()
        
        viewModel.changeHandler = { change in
            switch change {
            case .didFetchCoins:
                self.tableView.reloadData()
            case .didErrorOccurred(let error):
                self.showError(error)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension RecentPhotosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coin = viewModel.photoForIndexPath(indexPath) else {
            return
        }
        let viewModel = CryptoDetailViewModel(coin: coin)
        let viewController = CryptoDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RecentPhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CoinTableViewCell else {
            fatalError("CoinTableViewCell not found.")
        }
        guard let coin = viewModel.photoForIndexPath(indexPath) else {
            fatalError("coin not found.")
        }
        cell.imageView?.kf.setImage(with: coin.iconUrl) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
}
