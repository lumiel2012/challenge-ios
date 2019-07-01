//
//  RotativeBanner.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 26/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class RotativeBanner {
    
    private var bannerId:String = ""
    private var bannerImage:UIImage? = nil
    private var bannerLink:String = ""
    private var bannerImageURL:String = ""
    
    func getBannerId() -> String {
        return bannerId
    }
    
    func setBannerId(bannerId:String) {
        self.bannerId = bannerId
    }
    
    func getBannerImage() -> UIImage? {
        return bannerImage
    }
    
    func setBannerImage(bannerImage:UIImage) {
        self.bannerImage = bannerImage
    }

    func getBannerLink() -> String {
        return bannerLink
    }
    
    func setBannerLink(bannerLink:String) {
        self.bannerLink = bannerLink
    }
    
    func getBannerImageURL() -> String {
        return bannerImageURL
    }
    
    func setBannerImageURL(bannerImageURL:String) {
        self.bannerImageURL = bannerImageURL
    }
}
