//
//  SearchViewController.swift
//  Crypto App
//
//  Created by Emiralp Duman on 18.10.2022.
//

import UIKit
import Kingfisher

class SearchViewController: FAViewController {
    private var viewModel: SearchViewModel
    
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
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

