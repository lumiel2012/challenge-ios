//
//  RotativeBannerList.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 26/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation

class RotativeBannerManager {
    
    private var rotativeBanners:[Int:RotativeBanner] = [:]
    private var qtyBanners:Int = 0
    private var selectedIndex:Int = 0
    
    func getRotativeBanners() -> [Int:RotativeBanner] {
        return rotativeBanners
    }
    
    func setRotativeBanners(rb:[Int:RotativeBanner]) {
        rotativeBanners = rb
    }
    
    func getQtyBanners() -> Int {
        return qtyBanners
    }
    
    func setQtyBanners(qty:Int) {
        qtyBanners = qty
    }
    
    func getSelectedIndex() -> Int {
        return selectedIndex
    }
    
    func setSelectedIndex(index:Int) {
        selectedIndex = index
    }
}
