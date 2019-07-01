//
//  ProductManager.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 26/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation

class ProductManager {
    
    private var productModels:[Int:ProductModel] = [:]
    private var qtyProduct:Int = 0
    
    func getQtyProduct() -> Int {
        return qtyProduct
    }
    
    func setQtyProduct(qty:Int) {
        qtyProduct = qty
    }
    
    func getProductModels() -> [Int:ProductModel] {
        return productModels
    }
    
    func setProductModels(pdms:[Int:ProductModel]) {
        productModels = pdms
    }
}
