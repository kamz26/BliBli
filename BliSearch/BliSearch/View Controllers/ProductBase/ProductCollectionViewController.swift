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
    private let footerView = UIActivityIndicatorView(style: .gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    private func viewSetup(){
        productCollectionView.register(cellType: ProductCollectionViewCell.self)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        parentVc = self.parent as? ProductSearchBaseVc
        parentVc.reloadDelegate = self
        
        bottomViewSetup()
        
        if let layout = productCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        self.productCollectionView.reloadAsync()
    }
    
    private func bottomViewSetup(){
        productCollectionView.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        (productCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: productCollectionView.frame.size.width, height: 50)
    }
    
    
    @objc func rotated() {
        self.productCollectionView.reloadAsync()
    }
    
    deinit {
        NotificationCenter.default.removeObserver( #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
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
        return  parentVc.productImages[indexPath.item].size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
        
    }
}

extension ProductCollectionViewController:ReloadProtocol{
    func reloadViews() {
        DispatchQueue.main.async(execute: productCollectionView.reloadData)
        isPageRefreshing = false
    }
}



public class CollectionViewFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

