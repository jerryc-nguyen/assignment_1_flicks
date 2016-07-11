//
//  UISearchBar.swift
//  Flicks
//
//  Created by Welcome on 7/11/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredMovies = [NSDictionary]()
        if searchText.characters.count > 0 {
            filteredMovies = self.movies.filter({
                let title = $0["original_title"] as! String
                return title.lowercaseString.containsString(searchText.lowercaseString)
            })
            if filteredMovies.count > 0 {
                hideErrorMessage()
                self.filteredMovies = filteredMovies
            } else {
                showErrorMessage("No results found")
            }
            
        } else {
            self.filteredMovies = NSArray.init(array: self.movies, copyItems: true) as! [NSDictionary]
        }
        
        self.moviesTable.reloadData()
        self.moviesCollection.reloadData()
    }
}
