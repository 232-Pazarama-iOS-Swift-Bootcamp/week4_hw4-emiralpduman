//
//  Photo.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 8.10.2022.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    let url: String?
    let heightC, widthC: Int?

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case url = "url_c"
        case heightC = "height_c"
        case widthC = "width_c"
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
//    var prettyPrice: String {
//        "\(Double(round(100 * (price ?? .zero)) / 100)) ₺"
//    }
//
//    var change: Double {
//        guard let price = price,
//              let priceChange1w else { return .zero }
//        return Double(round(100 * (price * priceChange1w)) / 100)
//    }
//
//    var prettyChange: String {
//        if change > .zero {
//            return "↑ \(change) (\(priceChange1w ?? .zero)%)"
//        } else {
//            return "↓ \(change) (\(priceChange1w ?? .zero)%)"
//        }
//    }
//}
//
//extension Photo {
//    init(from dict: [String: Any]) {
//        id = dict["id"] as? String
//        icon = dict["icon"] as? String
//        name = dict["name"] as? String
//        symbol = dict["symbol"] as? String
//        rank = dict["rank"] as? Int
//        price = dict["price"] as? Double
//        priceBtc = dict["priceBtc"] as? Double
//        volume = dict["volume"] as? Double
//        marketCap = dict["marketCap"] as? Double
//        availableSupply = dict["availableSupply"] as? Double
//        totalSupply = dict["totalSupply"] as? Double
//        priceChange1h = dict["priceChange1h"] as? Double
//        priceChange1d = dict["priceChange1d"] as? Double
//        priceChange1w = dict["priceChange1w"] as? Double
//        websiteUrl = dict["websiteUrl"] as? String
//        twitterUrl = dict["twitterUrl"] as? String
//        exp = dict["exp"] as? [String]
//    }
//}
