//
//  MoviesCollectionViewExtension.swift
//  Flicks
//
//  Created by Welcome on 7/11/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit
extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

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
        cell.bindingDataFor(self.filteredMovies[movieIndex])
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let viewController = DetailsViewController.initFromStoryBoard()
        var movieIndex = self.itemPerRowOfCollection * indexPath.section + indexPath.row
        
        movieIndex = movieIndex < self.filteredMovies.count ? movieIndex : (self.filteredMovies.count - 1)
        let selectedMovie = self.filteredMovies[movieIndex]
        viewController.movieData = selectedMovie
        self.navigationController!.pushViewController(viewController, animated: true)
    }
}