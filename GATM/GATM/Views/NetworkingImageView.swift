//
//  NetworkingImageView.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 09/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

class NetworkingImageView: UIImageView {
    let imageCache = NSCache<NSString, UIImage>()
    var urlString: String?
    
    func loadUsingUrlString(_ urlString: String, indicator: UIActivityIndicatorView) {
        self.urlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            indicator.stopAnimating()
            return
        }
        indicator.startAnimating()
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(error ?? "😕")
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard
                    let self = self,
                    let imageToCache = UIImage(data: data!)
                    else { return }
                if self.urlString == urlString {
                    self.image = imageToCache
                    indicator.stopAnimating()
                }
                self.imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
        }).resume()
    }
    
}
