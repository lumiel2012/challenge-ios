//
//  CategoryProductListViewController.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 26/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class ProductCategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableProducts: UITableView!
    
    public var productCategoryName:String = ""
    public var productCategoryId:String = ""
    private var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    public var productManager:ProductManager = ProductManager()
    private var requestManager:RequestManager = RequestManager()
    private var rowLimit = 20
    private var rowOffset = 0
    
    public var myParent:HomeViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillHeader()
        
        tableProducts.accessibilityIdentifier = "tableProducts"
        tableProducts.dataSource = self
        tableProducts.delegate = self
        tableProducts.register(UINib(nibName: "ProductListTableViewCell", bundle: .main), forCellReuseIdentifier: "ProductListTableViewCell")
        
        self.fillProductsByCategoryId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillHeader()
    }
    
    func fillHeader() {
        
        self.navigationController!.navigationBar.topItem?.title = "Home"
        navigationItem.title = productCategoryName
    }

    func fillProductsByCategoryId() {
        var dictionaryProducts:[Int:ProductModel] = [:]
        var count:Int = 0
        var qtyTotal:Int = 0
        
        
        if(activityIndicator != nil) {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        
        DispatchQueue.global(qos: .default).async {
            if(self.productManager.getProductModels().count > 0) {
                dictionaryProducts = self.productManager.getProductModels()
                count = self.productManager.getProductModels().count-1
            }
            
            let productsByCategory = self.requestManager.requestGET(urlString:
                "https://alodjinha.herokuapp.com/produto?offset=\(self.rowOffset)" + "&limit=20&categoriaId=" + "\(self.productCategoryId)")

            if(productsByCategory != nil) {
                if let arrayProducts = productsByCategory!["data"] as? NSArray {
                    qtyTotal = arrayProducts.count
                    
                    for item in arrayProducts {
                        
                        let productModel = ProductModel()
                        var dictBestSells = item as! [String : Any]
                        let productId = dictBestSells["id"]
                        let productName = dictBestSells["nome"]
                        let productImageURL = dictBestSells["urlImagem"]
                        let productDescription = dictBestSells["descricao"]
                        let productPricePast = dictBestSells["precoDe"]
                        let productPriceNow = dictBestSells["precoPor"]
                        
                        productModel.setId(id: String(describing: productId!))
                        productModel.setName(name: String(describing: productName!))
                        productModel.setUrlImage(url: String(describing: productImageURL!))
                        productModel.setDescription(desc: String(describing: productDescription!))
                        productModel.setPricePast(price: Double(String(describing: productPricePast!))!)
                        productModel.setPriceNow(priceNow: Double(String(describing: productPriceNow!))!)
                        
                        dictionaryProducts.updateValue(productModel, forKey: count)
                        count = count + 1
                    }
                    
                    self.productManager.setQtyProduct(qty: qtyTotal)
                    self.productManager.setProductModels(pdms: dictionaryProducts)
                    
                     DispatchQueue.main.async {
                        if(self.activityIndicator != nil) {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                        self.tableProducts.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func touch_back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productManager.getProductModels().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.getProductCell(tableView: tableView, indexPath: indexPath)
        cell.myParent = myParent
        let index = indexPath.row
        cell.setup(productModel: self.productManager.getProductModels()[index]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 && productManager.getQtyProduct() >= 20 {
            rowOffset = rowOffset + 20
            fillProductsByCategoryId()
        }
    }
    
    func getProductCell(tableView: UITableView, indexPath: IndexPath) -> ProductListTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
    }
}
