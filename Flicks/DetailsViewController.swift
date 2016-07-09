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
    
    let imageBaseUrl = "https://image.tmdb.org/t/p/w342"
    
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
        let imageURL = getNSURLFor(imagePath!)
        self.detailImage.setImageWithURL(imageURL)
        // Do any additional setup after loading the view.
        
    }
    
    func getNSURLFor(imagePath: String) -> NSURL{
        let fullImageURLStr = self.imageBaseUrl + imagePath
        return NSURL(string: fullImageURLStr)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
