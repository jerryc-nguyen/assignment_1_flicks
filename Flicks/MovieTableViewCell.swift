//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Welcome on 7/9/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var featureImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var movieData = NSDictionary()
    
    func bindingDataFor(movieData: NSDictionary) {
        self.movieData = movieData
        
        title.text = movieData["original_title"] as? String
        overview.text = movieData["overview"] as? String
        let imagePath = movieData["backdrop_path"] as? String
        
        if imagePath != nil {
            let smallImageUrl = ImageHandler.fullImageURLFor(imagePath!)
            let originalImageUrl = ImageHandler.fullImageURLFor(imagePath!, isSmall: false)
            ImageHandler.loadPosters(smallImageUrl, largeImageURL: originalImageUrl, posterImageView: featureImage)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initViews()
    }
    
    func initViews() {
        selectedBackgroundView=UIView(frame: frame)
        selectedBackgroundView!.backgroundColor = UIColor.whiteColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
