//
//  FirstViewController.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 25/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var imageRotativeBanner: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableViewProducts: UITableView!
    
    private var myTabControl:UITabBarViewController? = nil
    private var requestManager:RequestManager = RequestManager()
    private var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    public var rotativeBannerManager:RotativeBannerManager = RotativeBannerManager()
    public var productManager:ProductManager = ProductManager()
    private var showProductByCategory:Bool = false
    private var selectedCategoryId:String = ""
    private var selectedCategoryName:String = ""
    private var selectedProduct:ProductModel? = nil
    
    // Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillHeader()
        tableViewProducts.dataSource = self
        tableViewProducts.delegate = self
        tableViewProducts.register(UINib(nibName: "ProductListTableViewCell", bundle: .main), forCellReuseIdentifier: "ProductListTableViewCell")
        
        self.fillBanners()
        self.fillCategory()
        self.fillBestSells()
        self.activateGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fillHeader()
    }

    @IBAction func touch_banner(_ sender: UIButton) {
        self.openBannerHyperlink()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productManager.getQtyProduct()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.getProductCell(tableView: tableView, indexPath: indexPath)
        cell.myParent = self
        cell.setup(productModel: self.productManager.getProductModels()[indexPath.row]!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.prepareNextViewController(for: segue)
    }
    
    // Methods
    @objc func tryShowBannerImage()
    {
        let bannerImage = appDelegate.shared.getLoadedBanner()
        if(bannerImage != nil) {
            imageRotativeBanner.image = bannerImage
        }
    }
    
    @objc func respondToSwipeGesture(_ sender : UISwipeGestureRecognizer) {
        
        var selected = rotativeBannerManager.getSelectedIndex()
        
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.left:
            
            selected = selected - 1
            if(selected >= 0) {
                updateBanner(index: selected)
            }
            else{
                updateBanner(index: 0)
            }
        case UISwipeGestureRecognizer.Direction.right:
            
            selected = selected + 1
            if(selected <= 2) {
                updateBanner(index: selected)
            }
            else{
                updateBanner(index: rotativeBannerManager.getQtyBanners()-1)
            }
        default:
            break
        }
    }
    
    func openBannerHyperlink() -> Void {
        if(rotativeBannerManager.getQtyBanners() > 0) {
                let selectedIndex = rotativeBannerManager.getSelectedIndex()
                let rotativeBanner = rotativeBannerManager.getRotativeBanners()[selectedIndex]
                let hyperlinkToShow = rotativeBanner?.getBannerLink()
            
                if let url = URL(string: hyperlinkToShow!) {
                UIApplication.shared.openURL(url)
                print("link openned")
            }
        }
    }
    
    func getProductCell(tableView: UITableView, indexPath: IndexPath) -> ProductListTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
    }
    
    func prepareNextViewController(for segue: UIStoryboardSegue) -> Void {
        if(self.showProductByCategory) {
            
            let destinationPCViewController = segue.destination as! ProductCategoryListViewController
            destinationPCViewController.productCategoryId = self.selectedCategoryId
            destinationPCViewController.productCategoryName = self.selectedCategoryName
            destinationPCViewController.myParent = self
        }
        else {
            
            let destinationPDViewController = segue.destination as! ProductDetailViewController
            destinationPDViewController.selectedProduct = self.selectedProduct
        }
    }
    
    func fillHeader() {
        myTabControl = (tabBarController as! UITabBarViewController)
        myTabControl!.configureTabBarHome()
    }
    
    public func callViewProductDetailByProductId(selectedProduct:ProductModel) {
        self.showProductByCategory = false
        self.selectedProduct = selectedProduct
        self.performSegue(withIdentifier: "segueMainToProductDetail", sender: nil)
    }
    
    public func callViewProductsByCategoryId(categoryId:String, categoryName:String) {
        self.showProductByCategory = true
        self.selectedCategoryId = categoryId
        self.selectedCategoryName = categoryName
        self.performSegue(withIdentifier: "segueHomeToProductCategoryList", sender: nil)
    }
    
    func fillBestSells() {
        var dictionaryBestSells:[Int:ProductModel] = [:]
        var count:Int = 0
        var qtyTotal:Int = 0
        
        let bestSells = requestManager.requestGET(urlString: "https://alodjinha.herokuapp.com/produto/maisvendidos")
        if(bestSells != nil) {
            if let arrayBestSells = bestSells!["data"] as? NSArray {
                qtyTotal = arrayBestSells.count
                
                for item in arrayBestSells {
                    
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
                    
                    dictionaryBestSells.updateValue(productModel, forKey: count)
                    count = count + 1
                }
                
                productManager.setQtyProduct(qty: qtyTotal)
                productManager.setProductModels(pdms: dictionaryBestSells)
            }
        }
    }
    
    func activateGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func updateBanner(index:Int) {
        
        if(rotativeBannerManager.getRotativeBanners().count > 0) {
            let dictionaryBanners = rotativeBannerManager.getRotativeBanners()
            let selectedBanner = dictionaryBanners[index]
            
            DispatchQueue.global().async {
                self.appDelegate.shared.downloadImage(urlString: selectedBanner!.getBannerImageURL())
                self.rotativeBannerManager.setSelectedIndex(index: index)
            }
        }
        
        if(pageControl != nil) {
            self.pageControl.currentPage = Int(index)
        }
    }
    
    func fillBanners() -> Void {
        
        var dictRotativeBanners:[Int:RotativeBanner] = [:]
        var qtyTotal:Int = 0
        var count:Int = 0
        
        let rotativeBanners = requestManager.requestGET(urlString: "https://alodjinha.herokuapp.com/banner")
        if(rotativeBanners != nil) {
            
                if let arrayRotativeBanners = rotativeBanners!["data"] as? NSArray {
                    qtyTotal = arrayRotativeBanners.count
                    
                    for item in arrayRotativeBanners {
                        
                        let dictRotativeBanner = item as! [String : Any]
                        let rotativeBanner:RotativeBanner = RotativeBanner()
                        
                        let valueId = dictRotativeBanner["id"]
                        let valueImage = dictRotativeBanner["urlImagem"]
                        let valueLink = dictRotativeBanner["linkUrl"]
                        
                        rotativeBanner.setBannerId(bannerId: String(describing: valueId!))
                        rotativeBanner.setBannerLink(bannerLink: String(describing: valueLink!))
                        rotativeBanner.setBannerImageURL(bannerImageURL: String(describing: valueImage!))
                        dictRotativeBanners.updateValue(rotativeBanner, forKey: count)
                        count = count + 1
                }
                    
                rotativeBannerManager.setQtyBanners(qty: qtyTotal)
                rotativeBannerManager.setRotativeBanners(rb: dictRotativeBanners)
                rotativeBannerManager.setSelectedIndex(index: 0)
                updateBanner(index: 0)
                _ = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(tryShowBannerImage), userInfo: nil, repeats: true)
                
                    if(pageControl != nil) {
                        
                        pageControl.numberOfPages = qtyTotal
                        
                    }
                    
            }
        }
    }
    
    func fillCategory() -> Void {
        
            let categoryProducts = requestManager.requestGET(urlString: "https://alodjinha.herokuapp.com/categoria")
            if(categoryProducts != nil) {
                if let arrayCategoryProducts = categoryProducts!["data"] as? NSArray {
                    for item in arrayCategoryProducts {
                        let dictCategoryProduct = item as! [String : Any]
                        let valueId = dictCategoryProduct["id"]
                        let valueDescription = dictCategoryProduct["descricao"]
                        let valueImage = dictCategoryProduct["urlImagem"]
                        
                        if let productCategory = Bundle.main.loadNibNamed("ProductCategory", owner: nil, options: nil)!.first as? ProductCategoryViewController
                        {
                            productCategory.myParent = self
                            productCategory.translatesAutoresizingMaskIntoConstraints = false
                            let horizontalFrameHeight = self.horizontalStackView.frame.height
                            productCategory.widthAnchor.constraint(equalToConstant: horizontalFrameHeight).isActive = true
                            
                            DispatchQueue.global().async {
                          
                                let urlImage = String(describing: valueImage!)
                                if(self.requestManager.checkIfValid(fullURL: urlImage)) {
                                    
                                    productCategory.categoryId = String(describing: valueId!)
                                    productCategory.categoryImage.imageFromUrl(urlString: urlImage)
                                    
                                    DispatchQueue.main.async {
                                        productCategory.categoryDescription.text = String(describing: valueDescription!)
                                        self.horizontalStackView.addArrangedSubview(productCategory)
                                    }
                                }
                                else {
                                    let urlImageDefault = UIImage(named: "noimage")
                                    productCategory.categoryId = String(describing: valueId!)
                                    DispatchQueue.main.async {
                                        productCategory.categoryDescription.text = String(describing: valueDescription!)
                                        productCategory.categoryImage.image = urlImageDefault
                                        self.horizontalStackView.addArrangedSubview(productCategory)
                                    }
                                    print(productCategory.categoryId + " noimage")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
