//
//  PhotoTableViewCell.swift
//  Flickr App
//
//  Created by Pazarama iOS Bootcamp on 8.10.2022.
//

import UIKit

final class PhotoTableViewCell: UITableViewCell {
    
    var isAlreadyFavourite = false
    var isAlreadyInLibrary = false
    
    //MARK: - UI Elements
    
    @IBOutlet private(set) weak var iconImageView: UIImageView!

    @IBOutlet weak var addToFavouriteButton: UIButton!
    @IBOutlet weak var addToLibraryButton: UIButton!
    
    //MARK: -Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addToLibraryButton.setTitle("", for: .normal)
        addToFavouriteButton.setTitle("", for: .normal)
    }
}
