//
//  SearchViewModel.swift
//  Flickr App
//
//  Created by Emiralp Duman on 18.10.2022.
//

import Foundation
import Moya
import FirebaseFirestore


final class SearchViewModel {
    private var photosResponse: PhotosResponse? {
        didSet {
            self.changeHandler?(.didFetchPhotos)
        }
    }
    
    private let db = Firestore.firestore()
    
    var changeHandler: ((RecentsListChanges) -> Void)?
    
    var numberOfRows: Int {
        
        photosResponse?.photos?.photo?.count ?? .zero
    }
    
    func fetchPhotos() {
        flickrApiProvider.request(.searchPhotos()) { result in
            switch result {
            case .failure(let error):
                self.changeHandler?(.didErrorOccurred(error))
            case .success(let response):
                do {
                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
                    
//self.addPhotosToFirebaseFirestore(photosResponse.photos?.photo)
                    
                    self.photosResponse = photosResponse
                } catch {
                    self.changeHandler?(.didErrorOccurred(error))
                }
            }
        }
    }
    
    func searchPhotos(keyword: String) {
        flickrApiProvider.request(.searchPhotos(keyword)) { result in
            switch result {
            case .failure(let error):
                self.changeHandler?(.didErrorOccurred(error))
            case .success(let response):
                do {
                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
                    
//self.addPhotosToFirebaseFirestore(photosResponse.photos?.photo)
                    
                    self.photosResponse = photosResponse
                } catch {
                    self.changeHandler?(.didErrorOccurred(error))
                }
            }
        }
    }
    
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
        photosResponse?.photos?.photo?[indexPath.row]
    }
}

