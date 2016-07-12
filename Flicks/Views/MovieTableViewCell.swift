//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Duy Nguyen on 11/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit
import AFNetworking

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var descriptionView: UILabel!
    
    let posterBaseUrl = "https://image.tmdb.org/t/p/w342"

    func initWithData(data: NSDictionary) {
        
        titleLabel?.text = data.valueForKeyPath("title") as? String
        descriptionView?.text = data.valueForKeyPath("overview") as? String
        
        if let posterPath = data["poster_path"] as? String {
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            photoView.setImageWithURL(posterUrl!, placeholderImage: UIImage(named: "movie-placeholder"))
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            photoView.image = nil
        }
    }
}
