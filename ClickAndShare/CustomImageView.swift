//
//  CustomImageView.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/18/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastUrl: String?
    
    func loadImage(urlString: String){
        guard let url = URL(string: urlString) else {return}
        self.lastUrl = urlString
        self.image = nil 
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return 
        }
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return
            }
            
            
            
            if url.absoluteString != self.lastUrl {
                return
            }
            let image = UIImage(data: data)
            
            imageCache[urlString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
            
            }.resume()
        
    }
}
