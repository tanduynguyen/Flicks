//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Duy Nguyen on 11/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    let posterBaseUrl = "https://image.tmdb.org/t/p/w342"
    let originalPosterBaseUrl = "https://image.tmdb.org/t/p/original"

    var data: NSDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func initWithData (data: NSDictionary) {
        
        self.view.layoutIfNeeded()
        self.title = data["title"] as? String
        titleLabel?.text = data.valueForKeyPath("title") as? String
        descriptionView?.text = data.valueForKeyPath("overview") as? String
        var delta = descriptionView?.frame.size.height
        descriptionView?.sizeToFit()
        delta = (descriptionView?.frame.size.height)! - delta!
        
        if let posterPath = data["poster_path"] as? String {
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            imageView.setImageWithURL(posterUrl!, placeholderImage: UIImage(named: "movie-placeholder"))
            let originalBaseUrl = NSURL(string: originalPosterBaseUrl + posterPath)
            imageView.setImageWithURL(originalBaseUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            imageView.image = nil
        }


        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height + delta!
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        
        var frame = detailView.frame
        frame.size.height += delta!
        detailView.frame = frame
    }
}
