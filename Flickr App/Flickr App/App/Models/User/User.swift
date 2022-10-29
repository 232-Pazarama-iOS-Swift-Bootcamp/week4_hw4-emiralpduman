//
//  User.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 16.10.2022.
//

import Foundation

struct User: Encodable {
    //MARK: - Properties
    
    let emailAddress: String
    var name: String
    
    //MARK: -TODO Profile picture is just a string!
    var profilePic: String = "Profile Pic is here!"
    
    var favorites: [Photo] = []
    var collection: [Photo] = []
    
    
    //MARK: - Init
    init (email: String, name: String = "") {
        self.emailAddress = email
        self.name = name
    }
}

extension User {
    init(from dict: [String: Any]) {
        name = (dict["name"] as? String)!
        emailAddress = (dict["emailAddress"] as? String)!
        profilePic = (dict["profilePic"] as? String)!
        favorites = (dict["favorites"] as? [Photo])!
        collection = (dict["collection"] as? [Photo])!
    }
}
