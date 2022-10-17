//
//  FavoritesViewController.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 13.10.2022.
//

import UIKit

final class FavoritesViewController: FAViewController {
    
    private let viewModel: FavoritesViewModel
    
    private var isAnyPhotoAddedToFavorites: Bool = true

    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Init
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        tabBarController?.tabBar.tintColor = .systemRed
        let tabBarIcon = UIImage(named: "favorite")
        tabBarItem = UITabBarItem(title: "Favorites",
                                  image: tabBarIcon,
                                  tag: .zero)
        
        let nib = UINib(nibName: "PhotoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        //fetchFavorites()
        
        NotificationCenter().addObserver(self,
                                         selector: #selector(self.didAnyPhotoAddedToFavorites),
                                         name: NSNotification.Name("didAnyPhotoAddedToFavorites"),
                                         object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAnyPhotoAddedToFavorites = true
        fetchFavorites()
    }
    
    // MARK: - Methods
    private func fetchFavorites() {
        if isAnyPhotoAddedToFavorites {
            isAnyPhotoAddedToFavorites = false
            viewModel.fetchFavorites { error in
                if let error = error {
                    self.showError(error)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func didAnyPhotoAddedToFavorites() {
        isAnyPhotoAddedToFavorites = true
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        // disabled code comes here
        // swiftlint:enable force_cast
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotoTableViewCell else {
            fatalError("PhotoTableViewCell not found.")
        }
        guard let photo = viewModel.photoForIndexPath(indexPath) else {
            fatalError("photo not found.")
        }
        
//        cell.title = coin.name
//        cell.price = coin.prettyPrice
        cell.imageView?.kf.setImage(with: photo.url) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
}
