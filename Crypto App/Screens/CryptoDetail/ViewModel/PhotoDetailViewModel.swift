//
//  PhotoDetailViewModel.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 9.10.2022.
//

import Foundation
import FirebaseFirestore

@objc
protocol PhotoDetailDelegate: AnyObject {
    @objc optional func didErrorOccurred(_ error: Error)
    @objc optional func didFetchChart()
    @objc optional func didPhotoAddedToFavorites()
}

final class PhotoDetailViewModel {
    weak var delegate: PhotoDetailDelegate?
    
    private let db = Firestore.firestore()
    
    private let defaults = UserDefaults.standard
    
    private var photo: Photo
    
    private(set) var chartResponse: ChartResponse? {
        didSet {
            delegate?.didFetchChart?()
        }
    }
    
//    var coinName: String? {
//        coin.name
//    }
//    
//    var price: String? {
//        coin.prettyPrice
//    }
//    
//    var rate: String? {
//        coin.prettyChange
//    }
//    
//    var isRatePositive: Bool {
//        (coin.priceChange1w ?? .zero) > .zero
//    }
//    
//    var iconUrl: URL {
//        coin.iconUrl
//    }
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func fetchChart() {
        guard let id = photo.id else { return }
        provider.request(.chart(id: id, period: "1w")) { result in
            switch result {
            case .failure(let error):
                self.delegate?.didErrorOccurred?(error)
            case .success(let response):
                do {
                    let chartResponse = try JSONDecoder().decode(ChartResponse.self, from: response.data)
                    self.chartResponse = chartResponse
                } catch {
                    self.delegate?.didErrorOccurred?(error)
                }
            }
        }
    }
    
    func addFavorite() {
        guard let id = photo.id,
              let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else {
            return
        }
        
        db.collection("users").document(uid).updateData([
            "favorites": FieldValue.arrayUnion([id])
        ])
        
        delegate?.didPhotoAddedToFavorites?()
    }
}
