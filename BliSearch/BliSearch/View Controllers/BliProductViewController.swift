//
//  BliProductViewController.swift
//  BliSearch
//
//  
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit

class BliProductViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var productsTableView: UITableView!
    
    
    //MARK: - Variables
    var parentVc:ProductSearchBaseVc!
    var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewSetup()
    }
    
    
    private func viewSetup(){
        //TableViewSetup
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.register(cellType: ProductTableViewCell.self)
        parentVc = self.parent as? ProductSearchBaseVc
        parentVc.reloadDelegate = self
        
    }


}

//MARK:- UITableView Delegate and DataSource
extension BliProductViewController: UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentVc.productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: ProductTableViewCell.self, for: indexPath)
        cell.configureCell(with: self.parentVc.productData[indexPath.row])
        cell.buyProductButton.addTapGestureRecognizer {
            Log.printLog(indexPath.row)
        }
        
        if indexPath.row == self.parentVc.productData.count - 1{
           //Get More Product Data
            addIndicator()
            parentVc.getMoreData()
        }
        return cell
    }
    
    func addIndicator(){
        spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: productsTableView.bounds.width, height: CGFloat(44))
        
        self.productsTableView.tableFooterView = spinner
        self.productsTableView.tableFooterView?.isHidden = false
    }
    
    
}

extension BliProductViewController:ReloadProtocol{
    func reloadViews() {
        self.productsTableView.reloadAsync()
    }
}



