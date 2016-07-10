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
    
    @IBOutlet var searchBar:UISearchBar!
    
    @IBOutlet weak var moviesTable: UITableView!

    @IBOutlet weak var moviesCollection: UICollectionView!
    
    let itemPerRowOfCollection = 2
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    let imageBaseUrl = "https://image.tmdb.org/t/p/w342"
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var movies = [NSDictionary]()
    var filteredMovies = [NSDictionary]()
    let refreshControl = UIRefreshControl()
    let refreshControlOnGridView = UIRefreshControl()
    
    var navigationTitle: String {
        let selectedIndex = self.navigationController?.tabBarController?.selectedIndex
        if selectedIndex == 0 {
            return "Now Playing Movies"
        } else {
            return "Top Rated Movies"
        }
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
    
    func getNSURLFor(imagePath: String) -> NSURL{
        let fullImageURLStr = self.imageBaseUrl + imagePath
        return NSURL(string: fullImageURLStr)!
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
        
        let selectedIndex = self.navigationController?.tabBarController?.selectedIndex
        var url = NSURL()
        if selectedIndex == 0 {
            url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        } else {
            url = NSURL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")!
        }
        
        let request = NSURLRequest(
            URL: url,
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
            
            if (error != nil) {
                // create the alert
                let alert = UIAlertController(title: "Nework error!", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                // show the alert
                self.presentViewController(alert, animated: true, completion: nil)
                self.view.hidden = true
                
            } else {
                let data = dataOrNil
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
