//
//  TopCategoryItemCell.swift
//  CiyaShop
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON


class SpecialDealProductItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var vwOffer: UIView!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblAvailability: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.rightView.backgroundColor = .white
        self.rightView.layer.borderWidth = 0.5
        self.rightView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.lblAvailability.font = UIFont.appRegularFontName(size: 12)

        
        self.lblProductName.font = UIFont.appRegularFontName(size: fontSize13)
        self.lblProductName.textColor = grayTextColor//secondaryColor.withAlphaComponent(0.8)
        
        self.lblPrice.font = UIFont.appBoldFontName(size: fontSize14)
        self.lblPrice.textColor = secondaryColor
        
        self.lblOffer.font = UIFont.appBoldFontName(size: fontSize12)
        self.lblOffer.textColor = .white
        
        self.vwOffer.roundTopLeftBottomRightCorners(radius: 6)
        self.vwOffer.backgroundColor = secondaryColor
        
        self.layoutIfNeeded()
    }
    

    
    func setProductData(product : JSON) {
        
        if let productTitle = product["name"].string {
            self.lblProductName.text = productTitle
        } else if let productTitle = product["title"].string {
            self.lblProductName.text = productTitle
        } else {
            self.lblProductName.text = " "
        }
        lblAvailability.attributedText = lblAvailability.setUpAvailabilityUI(color: greenColor, strAvailability: "" + getLocalizationString(key: "InStock"),stock:product["stock_quantity"].intValue)

        
        let imageUrl = product["app_thumbnail"].string
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.imgProduct.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                DispatchQueue.main.async {
                    if (image == nil) {
                        self.imgProduct.image =  UIImage(named: "noImage")
                    } else {
                        self.imgProduct.image =  image
                    }
                }
            }
        }
        
        
        let priceValue = product["price_html"].string!.withoutHtmlString()
        if priceValue == "" {
            self.lblPrice.text = " "
        } else {
//            self.lblPrice.setPriceForItem(product["price_html"].string!)
            self.lblPrice.setPriceForProductItem(str: product["price_html"].stringValue, isOnSale: product["on_sale"].boolValue, product: product)

            /*let regularPrice = product["regular_price"].doubleValue
            let salePrice = product["sale_price"].doubleValue
            
            if(product["on_sale"].boolValue)
            {
                self.lblPrice.attributedText = getFormattedPrice(regularPrice: regularPrice, salePrice: salePrice)
            }else{
                if "\(regularPrice)".isEmpty{
                    self.lblPrice.text = ""
                }else{
                    self.lblPrice.text = strCurrencySymbol  + " " + priceFormatter(priceValue: regularPrice)
                }
            }*/
        }
    
        if product["rating"].exists() {
            if product["rating"].stringValue != "" {
                self.ratingView.rating = Double(product["rating"].stringValue)!
            } else {
                self.ratingView.rating = 0
            }
        } else {
            if product["average_rating"].exists() {
                if product["average_rating"].stringValue != "" {
                    self.ratingView.rating = Double(product["average_rating"].stringValue)!
                } else {
                    self.ratingView.rating = 0
                }
            } else {
                self.ratingView.rating = 0
            }
        }
        
        
        if product["on_sale"].exists() && product["on_sale"].bool == true {
            if product["sale_price"].exists() && product["regular_price"].exists() {
                
                if product["regular_price"].floatValue == product["sale_price"].floatValue {
                    self.vwOffer.isHidden = true
                } else {
                    let discount = product["regular_price"].floatValue - product["sale_price"].floatValue
                    let discountPercentage = discount * 100 / product["regular_price"].floatValue
                    var strDiscount = ""
                    
                    if fmod(discountPercentage, 1.0) == 0.0 {
                        strDiscount = String(format: "%d%% %@", Int(discountPercentage) ,getLocalizationString(key: "OFF"))
                        self.lblOffer.text = strDiscount
                    } else {
                        strDiscount = String(format: "%.2f%% %@", discountPercentage ,getLocalizationString(key: "OFF"))
                        self.lblOffer.text = strDiscount
                    }
                    self.vwOffer.isHidden = false
                }
            } else {
                self.vwOffer.isHidden = true
            }
        } else {
            self.vwOffer.isHidden = true
        }
       
//        if checkItemExistsInWishlist(productId: product["id"].stringValue) {
//            self.btnFavourite.isSelected = true
//        } else {
//            self.btnFavourite.isSelected = false
//        }
//
//        if isCatalogMode {
//            self.btnAddtoCart.isHidden = true
//        } else {
//            if isAddtoCartEnabled {
//                self.btnAddtoCart.isHidden = false
//
//                if checkItemExistsInCart(productId: product["id"].stringValue) {
//                    self.btnAddtoCart.setImage(UIImage(named: "select-icon"), for: .selected)
//                    self.btnAddtoCart.isSelected = true
//                } else {
//                    self.btnAddtoCart.setImage(UIImage(named: "cart-icon"), for: .normal)
//                    self.btnAddtoCart.isSelected = false
//                }
//
//
//
//                if let inStock = product["in_stock"].bool {
//                    if inStock == true {
//                        self.btnAddtoCart.backgroundColor = secondaryColor
//                        self.btnAddtoCart.isEnabled = true
//                    } else {
//                        self.btnAddtoCart.isEnabled = false
//                        self.btnAddtoCart.backgroundColor = .red
//                    }
//                } else {
//                    self.btnAddtoCart.isEnabled = false
//                    self.btnAddtoCart.backgroundColor = .red
//                }
//
//                if let price = product["price"].double {
//                    if price == 0 {
//                        self.btnAddtoCart.isHidden = true
//                    } else {
//                        self.btnAddtoCart.isHidden = false
//                    }
//                }
//
//            } else {
//                self.btnAddtoCart.isHidden = true
//            }
//        }
    }
    
    
}
