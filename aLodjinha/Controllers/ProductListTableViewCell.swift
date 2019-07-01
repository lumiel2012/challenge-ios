//
//  ProductListTableViewCell.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 26/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class ProductListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellProductName: UILabel!
    @IBOutlet weak var cellProductPriceNow: UILabel!
    @IBOutlet weak var cellProductPricePast: UILabel!
    
    private var productId:String = ""
    private var selectedProduct:ProductModel? = nil
    
    public var myParent:HomeViewController? = nil
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(productModel: ProductModel) {
        
        selectedProduct = productModel
        
        productId = productModel.getId()
        cellProductName.text = productModel.getName()
        
        let pricePast = String(format: "De: %0.2f", productModel.getPricePast())
        let priceNow = String(format: "Por: %0.2f", productModel.getPriceNow())
        
        let attributeDecoration = NSAttributedString(string: pricePast, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        
        cellProductPricePast.text = pricePast
        cellProductPricePast.attributedText = attributeDecoration
        
        cellProductPriceNow.text = priceNow
        
        DispatchQueue.global().async {
            self.cellImage.imageFromUrl(urlString: productModel.getUrlImage())
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImage.image = nil
    }
    
    @IBAction func touch_product(_ sender: UIButton) {
        
        if(myParent != nil){
            self.selectedProduct!.setProductImage(productImage: self.cellImage.image)
            myParent?.callViewProductDetailByProductId(selectedProduct: self.selectedProduct!)
            print(self.productId)
        }
    }
    
}
