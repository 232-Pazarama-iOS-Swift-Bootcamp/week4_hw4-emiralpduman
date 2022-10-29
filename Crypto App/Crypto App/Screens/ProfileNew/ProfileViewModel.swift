//
//  ProfileViewModel.swift
//  Crypto App
//
//  Created by Emiralp Duman on 19.10.2022.
//

import Foundation
import Moya
import FirebaseFirestore

class ProfileViewModel: FireBaseFireStoreAccessible, UserDefaultsAccessible {
    var photoURLs: [String] = [] {
        didSet {
            self.changeHandler?(.didFetchPhotos)
        }
    }
    
    private let db = Firestore.firestore()
    
    var changeHandler: ((RecentsListChanges) -> Void)?
    
    var numberOfRows: Int {
        print("Fotoğraf sayısı: \(photoURLs.count)")
        
        return photoURLs.count
    }
    
    func getFavorites() {
        let userDbId = defaults.object(forKey: "uid")
        db.collection("favorites").whereField("userUid", isEqualTo: userDbId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let documentData: [String:Any] = document.data()
                        let photoURL = documentData["photoURL"] as! String
                        self.photoURLs.append(photoURL)
                        
                        

                    }
                }
        }
    }
    
    func getCollection() {
        let userDbId = defaults.object(forKey: "uid")
        db.collection("library").whereField("userUid", isEqualTo: userDbId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let documentData: [String:Any] = document.data()
                        let photoURL = documentData["photoURL"] as! String
                        self.photoURLs.append(photoURL)
                    }
                }
        }
    }
    
//    func fetchPhotos() {
//        flickrApiProvider.request(.searchPhotos()) { result in
//            switch result {
//            case .failure(let error):
//                self.changeHandler?(.didErrorOccurred(error))
//            case .success(let response):
//                do {
//                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
//
////self.addPhotosToFirebaseFirestore(photosResponse.photos?.photo)
//
//                    self.photoCollection = photosResponse
//                } catch {
//                    self.changeHandler?(.didErrorOccurred(error))
//                }
//            }
//        }
//    }
    
//    func searchPhotos(keyword: String) {
//        flickrApiProvider.request(.searchPhotos(keyword)) { result in
//            switch result {
//            case .failure(let error):
//                self.changeHandler?(.didErrorOccurred(error))
//            case .success(let response):
//                do {
//                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
//
////self.addPhotosToFirebaseFirestore(photosResponse.photos?.photo)
//
//                    self.photoCollection = photosResponse
//                } catch {
//                    self.changeHandler?(.didErrorOccurred(error))
//                }
//            }
//        }
//    }
    
//    private func addPhotosToFirebaseFirestore(_ photos: [Photo]?) {
//        guard let photos = photos else {
//            return
//        }
//        photos.forEach { photo in
//            do {
//                guard let data = try photo.dictionary, let id = photo.id else {
//                    return
//                }
//
//                db.collection("photos").document(id).setData(data) { error in
//
//                    if let error = error {
//                        self.changeHandler?(.didErrorOccurred(error))
//                    }
//                }
//            } catch {
//                self.changeHandler?(.didErrorOccurred(error))
//            }
//        }
//    }
    
    func photoForIndexPath(_ indexPath: IndexPath) -> Photo? {
        let photoURL = photoURLs[indexPath.row]
        return Photo(id: UUID().uuidString, url: URL(string: photoURL))
        
    }
}
