//
//  SecondViewController.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 25/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        self.fillHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fillHeader()
    }
    
    func fillHeader() {

        let myTab = tabBarController as! UITabBarViewController
        myTab.configureTabBarAbout()
    }
}
