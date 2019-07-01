//
//  ProductModel.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 26/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class ProductModel {
    
    private var id: String = ""
    private var name: String = ""
    private var urlImage: String = ""
    private var description: String = ""
    private var pricePast: Double = 0
    private var priceNow: Double = 0
    private var productImage: UIImage? = nil
    
    func getId() -> String {
        return id
    }
    
    func setId(id:String) {
        self.id = id
    }
    
    func getName() -> String {
        return name
    }
    
    func setName(name:String) {
        self.name = name
    }
    
    func getUrlImage() -> String {
        return urlImage
    }
    
    func setUrlImage(url:String) {
        self.urlImage = url
    }
    
    func getDescription() -> String {
        return description
    }
    
    func setDescription(desc:String) {
        self.description = desc
    }
    
    func getPricePast() -> Double {
        return pricePast
    }
    
    func setPricePast(price:Double) {
        self.pricePast = price
    }
    
    func getPriceNow() -> Double {
        return priceNow
    }
    
    func setPriceNow(priceNow:Double) {
        self.priceNow = priceNow
    }
    
    func getProductImage() -> UIImage? {
        
        let defaultImage = UIImage(named: "noimage")
        return productImage == nil ? defaultImage : productImage
    }
    
    func setProductImage(productImage:UIImage?) {
        self.productImage = productImage
    }
}
