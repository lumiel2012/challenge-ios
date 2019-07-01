//
//  Shared.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 26/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var convertToAttributedHTML: NSAttributedString? {
        guard let data = data(using: .utf8)
        else
        {
            return NSAttributedString()
        }
        
        do
        {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                .characterEncoding:String.Encoding.utf8.rawValue],
                documentAttributes: nil)
        }
        catch
        {
            return NSAttributedString()
        }
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        
        if let url = NSURL(string: urlString)
        {
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
            {
                (response, data, error) -> Void in
                if let imageData = data as NSData?
                {
                    self.image = UIImage(data: imageData as Data)
                    
                    if(self.image == nil) {
                        self.image = UIImage(named: "noimage")
                    }
                }
            }
        }
    }
}

class Shared {
    
    private var selectedCategory:String = ""
    private var loadedBanner:UIImage? = nil
    
    func getLoadedBanner() -> UIImage? {
        return loadedBanner
    }
    
    func getSelectedCategory() -> String {
        return selectedCategory
    }
    
    func setSelectedCategory(categoryId:String) {
        selectedCategory = categoryId
    }
    
    public func downloadImage(urlString: String) -> Void {
        
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
            { (response, data, error) -> Void in
                
                if let imageData = data as NSData? {
                    self.loadedBanner = UIImage(data: imageData as Data)
                }
            }
        }
    }
}
