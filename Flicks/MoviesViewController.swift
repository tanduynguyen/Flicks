//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Duy Nguyen on 11/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    
    let apiKey = "660d335023d450eb3cfd376d7b81de56"
    let nowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing?api_key="
    let topRatedURL = "https://api.themoviedb.org/3/movie/top_rated?api_key="
    let searchURL = "https://api.themoviedb.org/3/search/movie?query=%@&api_key=%@"
    var type = 0
    var data = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if searchBar?.text?.characters.count > 0 {
            type = 3
        } else {
            type = self.tabBarItem.tag
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar?.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        refreshControlAction(refreshControl)
    }

    
    func refreshControlAction(refreshControl: UIRefreshControl?) {
        
        var urlString = nowPlayingURL.stringByAppendingString(apiKey)
        if type == 1 {
            urlString = topRatedURL.stringByAppendingString(apiKey)
        } else if type == 3 {
            urlString = String(format: searchURL, searchBar.text!.stringByAddingPercentEncodingForRFC3986()!, apiKey)
        }
        
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(
            request,
            completionHandler: { (dataOrNil, response, error) in
                if error != nil {
                    
                    let alertView = UIAlertController(title: "Error", message: error?.description, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                } else if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        
                        //                        NSLog("response: \(responseDictionary)")
                        if let data = responseDictionary["results"] {
                            self.data = data as! [NSDictionary]
                        }
                        
                        self.tableView.reloadData()
                        
                        refreshControl?.endRefreshing()
                    }
                }
        });
        task.resume()
    }

}


extension MoviesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "MovieTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieTableViewCell") as? MovieTableViewCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MovieTableViewCell
        }
        
        cell!.initWithData(data[indexPath.row] as! NSDictionary)
        
        return cell!
    }
}

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let vc = UIStoryboard(name: "MovieDetailsViewController", bundle: nil).instantiateInitialViewController() as! MovieDetailsViewController
        vc.initWithData(data[indexPath.row] as! NSDictionary)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        performSearch()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
     
        performSearch()
    }
    
    func performSearch() {
        
        if searchBar?.text?.characters.count > 0 {
            type = 3
        }

        refreshControlAction(refreshControl)
        
        type = self.tabBarItem.tag
    }
}

extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumericCharacterSet()
        allowed.addCharactersInString(unreserved)
        return stringByAddingPercentEncodingWithAllowedCharacters(allowed)
    }
}
