//
//  RecentPhotosViewController.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 8.10.2022.
//

import UIKit
import Kingfisher

final class RecentPhotosViewController: FAViewController, UserDefaultsAccessible, FireBaseFireStoreAccessible  {
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
        
        
        
//        db.collection("users").whereField("userUid", isEqualTo: userDbId)
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let documentData: [String:Any] = document.data()
//                        let photoURL = documentData["photoURL"] as! String
//                        self.photoURLs.append(photoURL)
//
//
//
//                    }
//                }
//        }
        
        
        
        title = "Recent"
       
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PhotoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "photoTableViewCell")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoTableViewCell", for: indexPath) as? PhotoTableViewCell else {
            fatalError("PhotoTableViewCell not found.")
        }
        guard let photo = viewModel.photoForIndexPath(indexPath) else {
            fatalError("photo not found.")
        }
        cell.photo = photo
        cell.iconImageView.kf.setImage(with: photo.url) { _ in }
        return cell
    }
}
