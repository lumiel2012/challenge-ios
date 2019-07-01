//
//  UITabBarViewController.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 27/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class UITabBarViewController : UITabBarController {
 
    func configureTabBarHome() {
        let imagelogo = UIImage(named: "logonavigation")
        let titleLogoNav = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        titleLogoNav.image = imagelogo
        titleLogoNav.contentMode = .scaleAspectFit
        
        self.navigationItem.title = ""
        self.navigationItem.backBarButtonItem?.title = "Home"
        self.navigationItem.titleView = titleLogoNav
    }
    
    public func configureTabBarAbout() {
        self.navigationItem.titleView = nil
        self.navigationItem.title = "Sobre"
    }
}
