//
//  ProductCollectionViewController.swift
//  BliSearch
//
//  
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit

class ProductCollectionViewController: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    
    
    var parentVc:ProductSearchBaseVc!
    var isPageRefreshing:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewSetup()
    }
    
    private func viewSetup(){
        productCollectionView.register(cellType: ProductCollectionViewCell.self)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        parentVc = self.parent as? ProductSearchBaseVc
        parentVc.reloadDelegate = self
        
        
        if let layout = productCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        self.productCollectionView.reloadAsync()
    }


}

extension ProductCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentVc.productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ProductCollectionViewCell.self, for: indexPath)
        cell.configureCell(with: self.parentVc.productData[indexPath.row])
        return cell
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.productCollectionView.contentOffset.y >= (self.productCollectionView.contentSize.height - self.productCollectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                parentVc.getMoreData()
            }
        }
    }
    
    
}


//MARK: - PINTEREST LAYOUT DELEGATE
extension ProductCollectionViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return parentVc.productImages[indexPath.item].size.height
    }
}

extension ProductCollectionViewController:ReloadProtocol{
    func reloadViews() {
        DispatchQueue.main.async(execute: productCollectionView.reloadData)
        isPageRefreshing = false
    }
}



