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
    
    let posterPath = "https://image.tmdb.org/t/p/w342"

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
        
        var urlString = data.valueForKeyPath("poster_path") as! String
        urlString = posterPath.stringByAppendingString(urlString)
        imageView?.setImageWithURL(NSURL(string: urlString)!)

        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height + delta!
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        
        var frame = detailView.frame
        frame.size.height += delta!
        detailView.frame = frame
    }
}
