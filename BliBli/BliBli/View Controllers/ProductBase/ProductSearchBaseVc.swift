//
//  ProductSearchBaseVc.swift
//  BliSearch
//
//  
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit

enum ViewMode{
    case tableView
    case collectionView
}

protocol ReloadProtocol: class{
    func reloadViews()
}

class ProductSearchBaseVc: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var listViewBtn: UIImageView!
    
    
    //MARK: - Variables
    var productData:[Product] = []{
        didSet{
            self.reloadData()
        }
    }
    
    var productImages:[UIImage] = []
    
     var currentPage:Int = 0
     var searchText: String = ""
    
    var selectedViewMode:ViewMode = .tableView{
        didSet{
            self.viewModeSetup()
        }
    }
    
    lazy var productTableViewVc: BliProductViewController = {
        let vc = BliProductViewController.initFromNib()
        return vc
    }()
    
    lazy var productCollectionVc: ProductCollectionViewController = {
        let vc = ProductCollectionViewController.initFromNib()
        return vc
    }()
    
    var group = DispatchGroup()
    
    
    
    weak var reloadDelegate:ReloadProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
    }
    
    
    private func viewSetup(){
        viewModeSetup()
        searchBar.delegate = self
        
        listViewBtn.addTapGestureRecognizer {
            self.toggleViewMode()
        }
    }
    
    private func toggleViewMode(){
        switch self.selectedViewMode{
        case .tableView:
            self.selectedViewMode = .collectionView
        case .collectionView:
            self.selectedViewMode = .tableView
        }
    }
    
    private func viewModeSetup(){
        switch selectedViewMode {
        case .tableView:
            self.remove(asChildViewController: productCollectionVc)
            self.add(asChildViewController: productTableViewVc, childFrame: container.frame)
            
            listViewBtn.image = UIImage(named: "grid")
            
        case .collectionView:
            self.remove(asChildViewController: productTableViewVc)
            self.add(asChildViewController: productCollectionVc, childFrame: container.frame)
            
            listViewBtn.image = UIImage(named: "list")
        }
        reloadData()
    }
    
    private func reloadData(){
        self.reloadDelegate?.reloadViews()
    }
    
    func getMoreData(){
        currentPage = self.currentPage + 1
        self.getProductSearchList(query: self.searchText)
    }
    
    
    private func add(asChildViewController viewController: UIViewController, childFrame:CGRect) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = childFrame
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)

    }
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }

}


//MARK:- Search Delegate
extension ProductSearchBaseVc:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        self.perform(#selector(reload), with: nil, afterDelay: 0.5)

    }
    @objc func reload(){
        self.productData = []
        self.currentPage = 0
        self.getProductSearchList(query: self.searchText)
    }

}


//MARK:- API Calls
extension ProductSearchBaseVc{
    func getProductSearchList(query:String){
        
        ApiServices.shared.getProductSearchList(query: query,currentPage: currentPage, ProductSearchResponseModel.self) { (result) in
            
            switch result {
            case .success(let product):
                
                let localData = product.data?.products ?? []
                self.updateImages(data:localData)
               
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    fileprivate func updateImages(data:[Product]){
          data.map({ (product)  in
            if let url = product.images?.first, let urlObj = URL.init(string: url){
                self.group.enter()
                self.downloaded(from: urlObj){ (image) in
                    self.group.leave()
                    self.productImages.append(image)
                }
            }
           })
        
        self.group.notify(queue: .main) {
            self.productData.append(contentsOf: data)
        }
        
    }
    
    
        func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion:  ((_ image:UIImage) -> Void)? = nil) {
    //        contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                completion?(image)
            }.resume()
        }
    
}
