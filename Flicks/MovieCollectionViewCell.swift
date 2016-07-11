//
//  MovieCollectionViewCell.swift
//  Flicks
//
//  Created by Welcome on 7/10/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var featureImage: UIImageView!
    
    var movieData = NSDictionary()
    
    func bindingDataFor(movieData: NSDictionary) {
        self.movieData = movieData
        title.text = movieData["original_title"] as? String
        let imagePath = movieData["backdrop_path"] as? String
        if imagePath != nil {
            let smallImageUrl = ImageHandler.fullImageURLFor(imagePath!)
            let originalImageUrl = ImageHandler.fullImageURLFor(imagePath!, isSmall: false)
            ImageHandler.loadPosters(smallImageUrl, largeImageURL: originalImageUrl, posterImageView: featureImage)
        }
    }
    
}
