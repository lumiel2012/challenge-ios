//
//  ProductDetailViewController.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 26/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailViewController: UIViewController {
    
    public var selectedProduct:ProductModel? = nil
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPriceNow: UILabel!
    @IBOutlet weak var productPricePast: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var buttonReserve: UIButton!
    
    override func viewDidLoad() {
        self.fillHeader()
        self.fillProductDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fillHeader()
        self.fillProductDetails()
    }
    
    @IBAction func touch_reserve(_ sender: Any) {
        self.productReservation()
    }
    
    func fillHeader() {
        self.navigationController!.navigationBar.topItem?.title = "Voltar"
        navigationItem.title = selectedProduct!.getName()
    }
    
    func productReservation() {
        buttonReserve.isEnabled = false
        let requestManager:RequestManager = RequestManager()
        let reserveOK = requestManager.requestPOST(urlString: "https://alodjinha.herokuapp.com/produto/" + selectedProduct!.getId())
        
        if(reserveOK) {
            showAlert(viewController: self, title: "aLodjinha", message: "Produto reservado com sucesso", button: "OK", callback: self.OKButton)
            buttonReserve.isEnabled = true
        }
        else {
            showAlert(viewController: self, title: "aLodjinha", message: "Ocorreu um problema ao reservar o produto.", button: "OK", callback: self.OKButton)
            buttonReserve.isEnabled = true
        }
    }
    
    func fillProductDetails() {
        productImage.image = selectedProduct!.getProductImage()
        productName.text = selectedProduct!.getName()
        
        let pricePast = String(format: "De: %0.2f", selectedProduct!.getPricePast())
        let priceNow = String(format: "Por: %0.2f", selectedProduct!.getPriceNow())
        
        productPriceNow.text = priceNow
        
        let attributeDecoration = NSAttributedString(string: pricePast, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        
        productPricePast.text = pricePast
        productPricePast.attributedText = attributeDecoration
        
        let descriptionHTML:String = selectedProduct!.getDescription()
        productDescription.attributedText = descriptionHTML.convertToAttributedHTML
    }
    
    func OKButton() -> Void {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showAlert(viewController:UIViewController, title:String, message:String, button:String, callback:@escaping (() -> Void)){
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
        
            alert.addAction(UIAlertAction(title: button,
                                          style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
                                            callback()
            }))
            viewController.present(alert, animated: true, completion: {
        })
    }
    
}
