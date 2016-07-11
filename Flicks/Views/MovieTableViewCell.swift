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
    
    let posterPath = "https://image.tmdb.org/t/p/w342"

    func initWithData(data: NSDictionary) {
        
        titleLabel?.text = data.valueForKeyPath("title") as? String
        descriptionView?.text = data.valueForKeyPath("overview") as? String
        
        var urlString = data.valueForKeyPath("poster_path") as! String
        urlString = posterPath.stringByAppendingString(urlString)
        photoView?.setImageWithURL(NSURL(string: urlString)!)
    }
}
