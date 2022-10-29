//
//  Photo.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 8.10.2022.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
//    let id, owner, secret, server: String?
//    let farm: Int?
//    let title: String?
//    let ispublic, isfriend, isfamily: Int?
//    let url: URL?
//    let height, width: Int?
    
    let id: String?
    let url: URL?

    enum CodingKeys: String, CodingKey {
//        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
//        case url = "url_c"
//        case height = "height_c"
//        case width = "width_c"
        
        case id
        case url = "url_c"
    }
}


//extension Photo {
//    var iconUrl: URL {
//        guard let icon = icon,
//              let iconUrl = URL(string: icon) else {
//            fatalError("icon url not found.")
//        }
//        return iconUrl
//    }
//
////    var prettyPrice: String {
////        "\(Double(round(100 * (price ?? .zero)) / 100)) ₺"
////    }
////
////    var change: Double {
////        guard let price = price,
////              let priceChange1w else { return .zero }
////        return Double(round(100 * (price * priceChange1w)) / 100)
////    }
////
////    var prettyChange: String {
////        if change > .zero {
////            return "↑ \(change) (\(priceChange1w ?? .zero)%)"
////        } else {
////            return "↓ \(change) (\(priceChange1w ?? .zero)%)"
////        }
////    }
//}

extension Photo {
    init(from dict: [String: Any]) {
        id = dict["id"] as? String
        url = dict["url"] as? URL
    }
}
