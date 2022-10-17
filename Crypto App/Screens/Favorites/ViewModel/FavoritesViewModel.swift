//
//  FavoritesViewModel.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 13.10.2022.
//

import Foundation

final class FavoritesViewModel: FAViewModel {
    
    private var photos = [Photo]()
    
    var numberOfRows: Int {
        photos.count
    }
    
    func photoForIndexPath(_ indexPath: IndexPath) -> Photo? {
        photos[indexPath.row]
    }
    
    func fetchFavorites(_ completion: @escaping (Error?) -> Void) {
        
        photos = []
        
        guard let uid = uid else {
            return
        }
        
        db.collection("users").document(uid).getDocument() { (querySnapshot, err) in
            guard let data = querySnapshot?.data() else {
                return
            }
            let user = User(from: data)
            
            user.favorites?.forEach({ coinId in
                self.db.collection("photos").document(coinId).getDocument { (querySnapshot, err) in
                    if let err = err {
                        completion(err)
                    } else {
                        guard let data = querySnapshot?.data() else {
                            return
                        }
                        let photo = Photo(from: data)
                        self.photos.append(photo)
                        completion(nil)
                    }
                }
            })
        }
    }
}
