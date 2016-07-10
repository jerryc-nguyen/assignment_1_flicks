//
//  ImageHandler.swift
//  Flicks
//
//  Created by Welcome on 7/10/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import AFNetworking

class ImageHandler {
    
  
    static let baseSmallPath: String = "https://image.tmdb.org/t/p/w45"
    static let baseOriginalPath: String = "https://image.tmdb.org/t/p/original"
    
    static func fullImageURLFor(imagePath: String, isSmall: Bool = true) -> String {
        let base  = isSmall ? baseSmallPath : baseOriginalPath
        return base + imagePath
    }
    
    static func loadPosters(smallImageURL:String, largeImageURL:String, posterImageView:UIImageView) {
        // load small image
        print("Load small image for poster: \(smallImageURL)")
        loadImageFrom(smallImageURL, forImageView: posterImageView) { (smallImage) -> Void in
            // load large image
            print("Load large image for poster: \(largeImageURL)")
            loadImageFrom(largeImageURL, forImageView: posterImageView) { (largeImage) -> Void in
                posterImageView.image = largeImage
                
            }
        }
    }
    
    static func loadImageFrom(imageUrl: String, forImageView: UIImageView, callBack: ((loadedImage:UIImage) -> Void)? = nil) {
        let imgURLRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
        forImageView.setImageWithURLRequest(
            imgURLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image ) -> Void in
                callBack?(loadedImage: image)
                setThenFadeIn(forImageView, loadedImage: image)
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
          }
        )
    }
    
    static func setThenFadeIn(imageView: UIImageView, loadedImage: UIImage) {
        imageView.alpha = 0.0
        imageView.image = loadedImage
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            imageView.alpha = 1.0
        })
    }
}
