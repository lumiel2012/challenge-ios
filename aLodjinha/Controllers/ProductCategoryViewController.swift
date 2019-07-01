//
//  ProductCategoryViewController.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 25/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//
import UIKit

class ProductCategoryViewController: UIView {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryDescription: UILabel!
    private var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    public var categoryId:String = ""
    public var myParent:HomeViewController? = nil
    
    @IBAction func touchUpInside_CategoryButton(_ sender: UIButton) {
        if(myParent != nil) {
            myParent?.callViewProductsByCategoryId(categoryId: self.categoryId,
                                                   categoryName: self.categoryDescription.text!)
            print(self.categoryId)
        }
    }
}
