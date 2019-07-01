//
//  aLodjinhaTests.swift
//  aLodjinhaTests
//
//  Created by Ricardo Barros on 25/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import XCTest
@testable import aLodjinha

class aLodjinhaTests: XCTestCase {

    override func setUp() {
        
    }
    
    func testFillBanner() {
        let home = HomeViewController()
        home.fillBanners()
        
        XCTAssertTrue(home.rotativeBannerManager.getQtyBanners() > 0)
    }
    
    func testBestSellers() {
        let home = HomeViewController()
        home.fillBestSells()
        
        XCTAssertTrue(home.productManager.getQtyProduct() > 0)
    }
    
    func testCategories() {
        let home = HomeViewController()
        home.fillCategory()
        
        XCTAssertNotNil(home.productManager)
    }
    
    func testProductList() {
        let productList = ProductCategoryListViewController()
        productList.productCategoryId = "1"
        productList.productCategoryName = "Games"
        productList.fillProductsByCategoryId()
        
        XCTAssertNotNil(productList.productManager)
    }
}
