//
//  FlickrAPI.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 15.10.2022.
//

import Foundation
import Moya

let flickrApiProvider = MoyaProvider<FlickrAPI>()

enum FlickrAPI {
    case getRecentPhotos
    case searchPhotos(String = "outdoor")
}

extension FlickrAPI: TargetType {
    
    /*
     getRecentPhotos = https://www.flickr.com/services/rest/?api_key=c8876faae75a89bd6533b2ba76f2cf64&format=json&method=flickr.photos.getRecent&extras=url_c
     searchPhotos = https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=c8876faae75a89bd6533b2ba76f2cf64&text=outdoor&extras=url_c&format=json&nojsoncallback=1
     */
    
    var baseURL: URL {
        guard let url = URL(string: "https://www.flickr.com/services/rest") else {
            fatalError("Base URL not found or not in correct format.")
        }
        return url
    }
    
    var path: String {
        "/"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getRecentPhotos:
            let parameters: [String : Any] = ["method" : "flickr.photos.getRecent",
                                              "format" : "json",
                                              "nojsoncallback" : 1,
                                              "api_key" : "c8876faae75a89bd6533b2ba76f2cf64",
                                              "extras" : "owner_name, url_c"]
            return .requestParameters(parameters:  parameters, encoding: URLEncoding.queryString)
        case .searchPhotos(let searchText):
            let parameters: [String : Any] = ["method" : "flickr.photos.search",
                                              "format" : "json",
                                              "nojsoncallback" : 1,
                                              "api_key" : "c8876faae75a89bd6533b2ba76f2cf64",
                                              "extras" : "url_c",
                                              "text" : searchText ]
            return .requestParameters(parameters:  parameters, encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String : String]? {
        nil
    }
}
