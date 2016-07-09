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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
