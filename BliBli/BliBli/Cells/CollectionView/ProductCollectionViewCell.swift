//
//  ProductCollectionViewCell.swift
//  BliSearch
//
//  
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
       @IBOutlet weak var productNameLabel: UILabel!
       @IBOutlet weak var productDiscountedPrice: UILabel!
       @IBOutlet weak var productMrpPrice: UILabel!
       @IBOutlet weak var productImageView: UIImageView!
       @IBOutlet weak var locationLabel: UILabel!
       @IBOutlet weak var ratingView: FloatRatingView!
       @IBOutlet weak var ratingCountLabel: UILabel!
       @IBOutlet weak var buyProductButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with product:Product){
        productNameLabel.text = product.name
        productDiscountedPrice.text = product.price?.offerPriceDisplay
        productMrpPrice.attributedText = product.price?.strikeThroughPriceDisplay?.strikeThrough()
        productImageView.downloaded(from: product.images?.first ?? "")
        ratingView.rating = Double(product.review?.rating ?? -1 )
        ratingCountLabel.text = "(\(product.review?.count ?? -1))"
        locationLabel.text = product.location ?? ""
        
        configureVisiblity(with: product)
    }
    
    func configureVisiblity(with product: Product){
        //Show or hide
        productMrpPrice.isHidden = !((product.price?.strikeThroughPriceDisplay?.isEmpty) != nil)
        let shouldShowRating = product.review?.count ?? -1 > 0
        
        ratingView.isHidden = !shouldShowRating
        ratingCountLabel.isHidden = !shouldShowRating
    }

}
