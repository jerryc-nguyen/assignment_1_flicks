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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBar:UISearchBar!
    
    @IBOutlet weak var moviesTable: UITableView!
    
    let imageBaseUrl = "https://image.tmdb.org/t/p/w342"
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var movies = [NSDictionary]()
    var filteredMovies = [NSDictionary]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        self.navigationItem.titleView = self.searchBar
        
        self.moviesTable.dataSource = self
        self.moviesTable.delegate = self
        self.searchBar.delegate = self
        
        refreshControl.addTarget(self, action: #selector(loadMoviesData), forControlEvents: UIControlEvents.ValueChanged)
        moviesTable.insertSubview(refreshControl, atIndex: 0)
        
        super.viewDidLoad()
        
        loadMoviesData()
    }
   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredMovies = [NSDictionary]()
        if searchText.characters.count > 0 {
            filteredMovies = self.movies.filter({
                let title = $0["original_title"] as! String
                return title.containsString(searchText)
            })
            self.filteredMovies = filteredMovies
        } else {
            self.filteredMovies = NSArray.init(array: self.movies, copyItems: true) as! [NSDictionary]
        }
        
        self.moviesTable.reloadData()
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
        
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
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
                    
                    // Hide HUD once the network request comes back (must be done on main UI thread)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            } else if (error != nil) {
                print(error!.localizedDescription)
            }
            
        })
        task.resume()
    }
    

    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let nextVC = segue.destinationViewController as! DetailsViewController
//        let selectedMovie = self.movies[(moviesTable.indexPathForSelectedRow?.row)!]
//        nextVC.movieData = selectedMovie
//    }
  

}
