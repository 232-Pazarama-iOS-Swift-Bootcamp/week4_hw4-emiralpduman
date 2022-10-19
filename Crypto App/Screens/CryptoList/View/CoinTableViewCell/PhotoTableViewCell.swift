//
//  PhotoTableViewCell.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 8.10.2022.
//

import UIKit
import FirebaseFirestore


final class PhotoTableViewCell: UITableViewCell, FireBaseFireStoreAccessible, UserDefaultsAccessible {
    
    var photo: Photo?
    
    var isAlreadyFavourite = false
    var isAlreadyInLibrary = false
    
    //MARK: - UI Elements
    
    @IBOutlet private(set) weak var iconImageView: UIImageView!
    
    @IBAction func didAddToFavouriteButtonTapped(_ sender: UIButton) {
        if isAlreadyFavourite {
            return
        } else {
            let userDbId = defaults.object(forKey: "uid")
            let data: [String: Any] = ["userUid": userDbId,
                                       "photoURL": photo?.url?.absoluteString]
            db.collection("favorites").document(UUID().uuidString).setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Favorite relationship was succesfully added.")
                }
            }

        }
        
//        guard let photo = photo else {
//            fatalError("PhotoTableViewCell's photo propery is empty.")
//        }
//
//        let userDbId = defaults.object(forKey: "uid")
//
//        let sfReference = db.collection("users").document(userDbId as! String)
//
//        db.runTransaction({ (transaction, errorPointer) -> Any? in
//            let sfDocument: DocumentSnapshot
//            do {
//                try sfDocument = transaction.getDocument(sfReference)
//            } catch let fetchError as NSError {
//                errorPointer?.pointee = fetchError
//                return nil
//            }
//
//            let fieldToChange = "favorites"
//
//
//            guard let oldFavourites = sfDocument.data()?[fieldToChange] as? Array<Photo> else {
//                let error = NSError(
//                    domain: "AppErrorDomain",
//                    code: -1,
//                    userInfo: [
//                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
//                    ]
//                )
//                errorPointer?.pointee = error
//                return nil
//            }
//            var resultingFavorites: [Photo] = oldFavourites
//            resultingFavorites.append(photo)
//
//            transaction.updateData([fieldToChange: resultingFavorites], forDocument: sfReference)
//            return nil
//        }) { (object, error) in
//            if let error = error {
//                print("Transaction failed: \(error)")
//            } else {
//                print("Transaction successfully committed!")
//            }
//        }
    }
    
    
    
    @IBAction func didAddToLibraryButtonTapped(_ sender: UIButton) {
        if isAlreadyInLibrary {
            return
        } else {
            let userDbId = defaults.object(forKey: "uid")
            let data: [String: Any] = ["userUid": userDbId,
                                       "photoURL": photo?.url?.absoluteString]
            db.collection("library").document(UUID().uuidString).setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Favorite relationship was succesfully added.")
                }
            }
            
        }
    }
    
    @IBOutlet weak var addToFavouriteButton: UIButton!
    @IBOutlet weak var addToLibraryButton: UIButton!
    
    //MARK: -Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addToLibraryButton.setTitle("", for: .normal)
        addToFavouriteButton.setTitle("", for: .normal)
    }
}

