//
//  SearchViewController.swift
//  Crypto App
//
//  Created by Emiralp Duman on 18.10.2022.
//

import UIKit

class SearchViewController: FAViewController {
    private var viewModel: SearchViewModel

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        let tabBarIcon = Asset.home.image
        tabBarItem = UITabBarItem(title: "Search",
                                  image: tabBarIcon,
                                  tag: .zero)
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        searchBar.delegate = self
        
        let nib = UINib(nibName: "SearchCollectionViewCell", bundle: nil)
        photosCollectionView.register(nib, forCellWithReuseIdentifier: "searchCollectionViewCell")
//        tableView.rowHeight = 500
        
        viewModel.fetchPhotos()
        
        viewModel.changeHandler = { change in
            switch change {
            case .didFetchPhotos:
                self.photosCollectionView.reloadData()
            case .didErrorOccurred(let error):
                self.showError(error)
            }
        }
        
    }
}
// MARK: - UITableViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel.photoForIndexPath(indexPath) != nil else {
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            fatalError("SearchCollectionViewCell not found.")

        }
        guard let photo = viewModel.photoForIndexPath(indexPath) else {
            fatalError("photo not found.")
        }
        cell.imageView.kf.setImage(with: photo.url) { _ in }
        return cell

    }
}

class photosCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = 3
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        let cellAspectRatio: CGFloat = 3/4
        let cellHeight: CGFloat = cellWidth * cellAspectRatio
        
        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let defaultInset: CGFloat = 20
        
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: defaultInset, bottom: defaultInset, right: defaultInset)
        self.sectionInsetReference = .fromSafeArea
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.count > 1 {
            viewModel.searchPhotos(keyword: text)
        }
    }
}



