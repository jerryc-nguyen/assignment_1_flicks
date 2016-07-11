//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Welcome on 7/9/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var networkErrorMessage: UILabel!
    
    @IBOutlet var searchBar:UISearchBar!
    
    @IBOutlet weak var moviesTable: UITableView!

    @IBOutlet weak var moviesCollection: UICollectionView!
    
    let itemPerRowOfCollection = 2
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    let playingURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let ratedURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    var movies = [NSDictionary]()
    var filteredMovies = [NSDictionary]()
    let refreshControl = UIRefreshControl()
    let refreshControlOnGridView = UIRefreshControl()
    
    var navigationTitle: String {
        if self.selectedTabBarIndex == 0 {
            return "Now Playing Movies"
        } else {
            return "Top Rated Movies"
        }
    }
    
    var selectedTabBarIndex: Int {
        return (self.navigationController?.tabBarController?.selectedIndex)!
    }
    
    static func initFromStoryBoard ()-> MoviesViewController{
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryBoard.instantiateViewControllerWithIdentifier("MoviesViewController") as! MoviesViewController
    }
    
    override func viewDidLoad() {
        showListMovies()
        customizeNavigationBar()

        self.moviesTable.dataSource = self
        self.moviesTable.delegate = self
        
        self.moviesCollection.dataSource = self
        self.moviesCollection.delegate = self
        
        self.searchBar.delegate = self
        
        refreshControl.backgroundColor = view.backgroundColor
        refreshControlOnGridView.backgroundColor = view.backgroundColor
        
        refreshControl.addTarget(self, action: #selector(loadMoviesData), forControlEvents: UIControlEvents.ValueChanged)
        
        refreshControlOnGridView.addTarget(self, action: #selector(loadMoviesData), forControlEvents: UIControlEvents.ValueChanged)
        
        moviesCollection.insertSubview(refreshControlOnGridView, atIndex: 0)
        
        moviesTable.insertSubview(refreshControl, atIndex: 0)
        
        super.viewDidLoad()
        
        loadMoviesData()
    }
    
    @IBAction func onDisplayModeChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showListMovies()
        } else {
            showGridMovies()
        }
    }
    
    func customizeNavigationBar() {
        self.navigationItem.title = self.navigationTitle
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            shadow.shadowOffset = CGSizeMake(2, 2);
            shadow.shadowBlurRadius = 4;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(22),
                NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        }
    }
    
    func showNetworkErrorMessage() {
        self.networkErrorMessage.hidden = false
        self.moviesTable.hidden = true
        self.moviesCollection.hidden = true
    }
    
    func hideNetworkErrorMessage() {
        self.networkErrorMessage.hidden = true
        self.moviesTable.hidden = false
        self.moviesCollection.hidden = false
    }
    
    func showListMovies() {
        self.moviesTable.hidden = false
        self.moviesCollection.hidden = true
    }
    
    func showGridMovies() {
        self.moviesTable.hidden = true
        self.moviesCollection.hidden = false
    }
    
    func movieForIndexPath(indexPath: NSIndexPath) -> NSDictionary {
        return self.filteredMovies[indexPath.section]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadMoviesData() {
        self.refreshControl.endRefreshing()
        self.refreshControlOnGridView.endRefreshing()
        
        let urlStr = self.selectedTabBarIndex == 0 ? self.playingURL : self.ratedURL
        
        let request = NSURLRequest(
            URL: NSURL(string: urlStr)!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
            
            if error != nil {
                self.networkErrorMessage.text = error!.localizedDescription
                self.showNetworkErrorMessage()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            } else {
                let data = dataOrNil
                self.hideNetworkErrorMessage()
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data!, options:[]) as? NSDictionary {
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.filteredMovies = NSArray.init(array: self.movies, copyItems: true) as! [NSDictionary]
                    
                    self.moviesTable.reloadData()
                    self.moviesCollection.reloadData()
                    
                    // Hide HUD once the network request comes back (must be done on main UI thread)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }
        })
        task.resume()
    }
    
}
