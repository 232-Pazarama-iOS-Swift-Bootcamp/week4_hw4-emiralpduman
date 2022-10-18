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
    
    var userName: String = "UserName" {
        didSet {
            userNameLabel.text = userName
        }
    }
    
    
    //MARK: -Views
    @IBOutlet weak var userNameLabel: UILabel!
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
        
        let nib = UINib(nibName: "PhotoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 500
        
        viewModel.fetchPhotos()
        
        viewModel.changeHandler = { change in
            switch change {
            case .didFetchPhotos:
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
        guard viewModel.photoForIndexPath(indexPath) != nil else {
            return
        }
//        let viewModel = PhotoDetailViewModel(photo: photo)
//        let viewController = CryptoDetailViewController(viewModel: viewModel)
//        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RecentPhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotoTableViewCell else {
            fatalError("PhotoTableViewCell not found.")
        }
        guard let photo = viewModel.photoForIndexPath(indexPath) else {
            fatalError("photo not found.")
        }
        cell.iconImageView.kf.setImage(with: photo.url) { _ in }
        return cell
    }
}
