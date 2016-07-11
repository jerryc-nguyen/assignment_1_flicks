//
//  MoviesTableViewExtension.swift
//  Flicks
//
//  Created by Welcome on 7/10/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.moviesTable.dequeueReusableCellWithIdentifier("MovieTableViewCell") as! MovieTableViewCell
        let currentMovie = self.filteredMovies[indexPath.row]
        cell.bindingDataFor(currentMovie)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = DetailsViewController.initFromStoryBoard()
        let selectedMovie = self.filteredMovies[indexPath.row]
        viewController.movieData = selectedMovie
        self.navigationController!.pushViewController(viewController, animated: true)
    }

}
