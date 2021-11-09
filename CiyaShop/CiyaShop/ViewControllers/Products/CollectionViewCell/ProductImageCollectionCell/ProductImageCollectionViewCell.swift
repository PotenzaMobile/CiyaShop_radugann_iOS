//
//  ProductImageCollectionViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 14/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProductImageCollectionViewCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet var imgvwProduct : UIImageView!
    @IBOutlet var imgvwSelect : UIImageView!
    @IBOutlet var vwSelect : UIView!
    @IBOutlet var btnPlayPause : UIButton!

    //MARK:- Variables
    var dictImage = JSON()
    
    //MARK:-Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgvwSelect.tintColor = .white
        btnPlayPause.makeRoundButton()
        btnPlayPause.isHidden = true
        vwSelect.isHidden = true
    }
    
    func setUpImageData()
    {
        btnPlayPause.isHidden = true
        let imageUrl = dictImage["src"].stringValue
        self.imgvwProduct.sd_setImage(with: imageUrl.encodeURL(), placeholderImage: UIImage(named: "placeholder"))
        
        /*self.imgvwProduct.sd_setImage(with: imageUrl.encodeURL() as URL) { (image, error, cacheType, imageURL) in
//                DispatchQueue.main.async {
                if (image == nil) {
                    self.imgvwProduct.image =  UIImage(named: "noImage")
                } else {
                    self.imgvwProduct.image =  image
                }
//                }
        }*/

    }
    
    func setUpVideoImage(dictVideo : [String:JSON])
        {
            btnPlayPause.isHidden = false
        let imageUrl = dictVideo["image_url"]!.stringValue
            self.imgvwProduct.sd_setImage(with: imageUrl.encodeURL(), placeholderImage: UIImage(named: "placeholder"))
            
            /*self.imgvwProduct.sd_setImage(with: imageUrl.encodeURL() as URL) { (image, error, cacheType, imageURL) in
    //                DispatchQueue.main.async {
                    if (image == nil) {
                        self.imgvwProduct.image =  UIImage(named: "noImage")
                    } else {
                        self.imgvwProduct.image =  image
                    }
    //                }
            }*/

        }

}
