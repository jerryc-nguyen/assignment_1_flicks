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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    static func initFromStoryBoard ()-> MoviesViewController{
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryBoard.instantiateViewControllerWithIdentifier("MoviesViewController") as! MoviesViewController
    }
    
    override func viewDidLoad() {
        showListMovies()
        
        self.navigationItem.titleView = self.searchBar
        
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
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("item badgeValue", item.badgeValue)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredMovies = [NSDictionary]()
        if searchText.characters.count > 0 {
            filteredMovies = self.movies.filter({
                let title = $0["original_title"] as! String
                return title.lowercaseString.containsString(searchText.lowercaseString)
            })
            self.filteredMovies = filteredMovies
        } else {
            self.filteredMovies = NSArray.init(array: self.movies, copyItems: true) as! [NSDictionary]
        }
        
        self.moviesTable.reloadData()
        self.moviesCollection.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.filteredMovies.count / self.itemPerRowOfCollection
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemPerRowOfCollection
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.moviesCollection.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        var movieIndex = self.itemPerRowOfCollection * indexPath.section + indexPath.row
        
        movieIndex = movieIndex < self.filteredMovies.count ? movieIndex : (self.filteredMovies.count - 1)
        let currentMovie = self.filteredMovies[movieIndex]
        
        cell.title.text = currentMovie["original_title"] as? String
        let imagePath = currentMovie["backdrop_path"] as? String
        let imageURL = self.getNSURLFor(imagePath!)
        cell.featureImage.setImageWithURL(imageURL)
        
        return cell
    }

    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.moviesTable.dequeueReusableCellWithIdentifier("MovieTableViewCell") as! MovieTableViewCell
        let currentMovie = self.filteredMovies[indexPath.row]
        cell.title.text = currentMovie["original_title"] as? String
        cell.overview.text = currentMovie["overview"] as? String
        let imagePath = currentMovie["backdrop_path"] as? String
        let imageURL = self.getNSURLFor(imagePath!)
        cell.featureImage.setImageWithURL(imageURL)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = DetailsViewController.initFromStoryBoard()
        let selectedMovie = self.filteredMovies[indexPath.row]
        viewController.movieData = selectedMovie
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    func getNSURLFor(imagePath: String) -> NSURL{
        let fullImageURLStr = self.imageBaseUrl + imagePath
        return NSURL(string: fullImageURLStr)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let data = dataOrNil
            if (error == nil && data != nil ) {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data!, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.filteredMovies = NSArray.init(array: self.movies, copyItems: true) as! [NSDictionary]
                    
                    self.moviesTable.reloadData()
                    self.moviesCollection.reloadData()
                    
                    // Hide HUD once the network request comes back (must be done on main UI thread)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            } else if (error != nil) {
                print(error!.localizedDescription)
            }
            
        })
        task.resume()
    }
    

}
