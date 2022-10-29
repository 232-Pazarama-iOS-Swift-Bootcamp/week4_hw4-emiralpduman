//
//  ProfileViewController.swift
//  Flickr App
//
//  Created by Emiralp Duman on 19.10.2022.
//

import UIKit



class ProfileViewController: FAViewController, UserDefaultsAccessible, FireBaseFireStoreAccessible{
    enum ProfileCollectionType: String {
        case favorites = "Favorites"
        case collection = "Collection"
    }
    
    var userName: String = "UserName" {
        didSet {
            userNameLabel.text = userName
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!
    
    private var profileCollectionMode: ProfileCollectionType = .favorites {
        didSet {
            switch profileCollectionMode {
            case .favorites:
                viewModel.getFavorites()
            case .collection:
                viewModel.getCollection()
            }
        }
    }
    
    
    private var viewModel: ProfileViewModel
    
    
    
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction private func didValueChangedSegmentedControl(_ sender: UISegmentedControl) {
        let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        profileCollectionMode = ProfileCollectionType(rawValue: title!)!
        viewModel.photoURLs.removeAll()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        let userDbId = defaults.object(forKey: "uid")
        
        let docRef = db.collection("users").document(userDbId as! String)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                self.userName = dataDescription!["emailAddress"] as! String
 
            } else {
                print("Document does not exist")
            }
        }
        

        
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        let nib = UINib(nibName: "SearchCollectionViewCell", bundle: nil)
        profileCollectionView.register(nib, forCellWithReuseIdentifier: "searchCollectionViewCell")
        //        tableView.rowHeight = 500
        
        switch profileCollectionMode {
        case .favorites:
            viewModel.getFavorites()
        case .collection:
            viewModel.getCollection()
        }
        
        viewModel.changeHandler = { change in
            switch change {
            case .didFetchPhotos:
                self.profileCollectionView.reloadData()
            case .didErrorOccurred(let error):
                self.showError(error)
            }
        }
        
    }
}
// MARK: - UITableViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel.photoForIndexPath(indexPath) != nil else {
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            fatalError("SearchCollectionViewCell not found.")
            
        }
        guard let photo = viewModel.photoForIndexPath(indexPath) else {
            fatalError("photo not found.")
        }
        cell.imageView.kf.setImage(with: photo.url) { _ in }
        return cell
        
    }
}

class ProfileCollectionViewFlowLayout: UICollectionViewFlowLayout {
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


