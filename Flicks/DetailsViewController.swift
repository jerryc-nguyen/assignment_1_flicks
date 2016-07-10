//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Welcome on 7/9/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var popularity: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var overview: UILabel!
    
    var movieData = NSDictionary()
    
    static func initFromStoryBoard ()-> DetailsViewController{
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryBoard.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.date.text = movieData["release_date"] as? String
        self.movieTitle.text = movieData["original_title"] as? String
        let  popularity = movieData["popularity"] as? NSNumber
        self.popularity.text = popularity?.stringValue
        self.duration.text = "123"
        self.overview.text = movieData["overview"] as? String
        let imagePath = movieData["backdrop_path"] as? String
        let smallImageUrl = ImageHandler.fullImageURLFor(imagePath!)
        let originalImageUrl = ImageHandler.fullImageURLFor(imagePath!, isSmall: false)
        
        ImageHandler.loadPosters(smallImageUrl, largeImageURL: originalImageUrl, posterImageView: self.detailImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
