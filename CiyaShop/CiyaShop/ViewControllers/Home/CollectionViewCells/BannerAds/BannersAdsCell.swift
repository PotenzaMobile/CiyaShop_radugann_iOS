//
//  TopCategoriesCell.swift
//  CiyaShop
//
//  Created by Apple on 22/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class BannersAdsCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var cvBannerAds: UICollectionView!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    
    var timer = Timer()
    var counter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cvBannerAds.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        setupCollectionView()

    }
    
    // MARK: - Configuration
       private func setupCollectionView() {
        
        cvBannerAds.delegate = self
        cvBannerAds.dataSource = self
        cvBannerAds.backgroundColor = UIColor.red
        cvBannerAds.setBackgroundColor()
        
//        if let layout = cvBannerAds.collectionViewLayout as? MMBannerLayout {
//            layout.itemSpace = 10
//            layout.itemSize = UIScreen.main.bounds.insetBy(dx: 10, dy: 10).size
//            layout.minimuAlpha = 1
//        }
        
        cvBannerAds.register(UINib(nibName: "BannerAdsItemCell", bundle: nil), forCellWithReuseIdentifier: "BannerAdsItemCell")
        
        cvWidthConstraint.constant = screenWidth
    
        self.cvBannerAds.reloadData()
       
//        (cvBannerAds.collectionViewLayout as? MMBannerLayout)?.setInfinite(isInfinite: true, completed: nil)
//        (cvBannerAds.collectionViewLayout as? MMBannerLayout)?.angle = 0
//
        //        DispatchQueue.main.async {
        //            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        //        }
        
        if isRTL {
            cvBannerAds.semanticContentAttribute = .forceRightToLeft
        }
        
    }
    
    
//    @objc func changeImage() {
//        if counter < arrSliders.count {
//            let index = IndexPath.init(item: counter, section: 0)
//            cvBannerAds.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
////            pageView.currentPage = counter
//            counter += 1
//        } else {
//            counter = 0
//            let index = IndexPath.init(item: counter, section: 0)
//            cvBannerAds.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
////            pageView.currentPage = counter
//            counter = 1
//        }
//
//    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        print("systemLayoutSizeFitting called")

        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        
        cvWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = self.cvBannerAds.contentSize.height
        
        return  CGSize(width: self.cvBannerAds.contentSize.width, height: self.cvBannerAds.contentSize.height)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let obj = object as? UICollectionView {
            if obj == self.cvBannerAds && keyPath == "contentSize"
            {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    print("newSize Review contentsize - ",newSize)
                    
                    self.cvHeightConstraint.constant = self.cvBannerAds.contentSize.height
                    
                    
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                }
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("Layout subview called")
        
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        
        cvWidthConstraint.constant = screenWidth
        cvHeightConstraint.constant = self.cvBannerAds.contentSize.height
        
        
        
    }

    // MARK: - UICollection Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        return arrBannersAd.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerAdsItemCell", for: indexPath) as! BannerAdsItemCell
        
        
        let imageUrl = arrBannersAd[indexPath.row]["banner_ad_image_url"].string
        
        if imageUrl != nil && !imageUrl!.isEmpty{
            cell.imgBanner.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                if (image == nil) {
                    cell.imgBanner.image = UIImage(named: "noImage")
                }
            }
        } else {
            cell.imgBanner.image = UIImage(named: "noImage")
        }
       // cell.imgBanner.image = cell.resizeImage(image: cell.imgBanner.image ?? UIImage(), targetSize: CGSize(width: collectionView.frame.size.width , height: 140*collectionView.frame.size.width/375))
        
        
//        let size = CGSize(width: collectionView.frame.size.width-80 , height: 140*collectionView.frame.size.width/375)
//
//        print("Image size - (%@,%@)",size.width,size.height)
//
//
//        let newImage = cell.resizeImage(image: cell.imgBanner.image ?? UIImage(), targetSize: CGSize(width: collectionView.frame.size.width-80 , height: 140*collectionView.frame.size.width/375))
//        cell.imgBanner.image = newImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        /*var img = UIImage()
        let imgVw = UIImageView()
        imgVw.contentMode = .scaleAspectFit
        let imageUrl = arrBannersAd[indexPath.row]["banner_ad_image_url"].string
        if imageUrl != nil && !imageUrl!.isEmpty{
            imgVw.sd_setImage(with: imageUrl!.encodeURL() as URL) { (image, error, cacheType, imageURL) in
                if (image == nil) {
                    img = UIImage(named: "noImage")!
                }
            }
        } else {
            img = UIImage(named: "noImage")!
        }
        
        return CGSize(width: imgVw.bounds.width, height: imgVw.bounds.height)*/
        
        return CGSize(width: collectionView.frame.size.width-80 , height: 140*collectionView.frame.size.width/375)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let dict = arrBannersAd[indexPath.row]
        let subcategories =  arrAllCategories.filter({$0["parent"].stringValue == dict["banner_ad_cat_id"].stringValue})
        var categoryWithProduct = subcategories
        categoryWithProduct.removeAll()
        subcategories.forEach{ (category) in
            if category["product_count"].intValue > 0{
                categoryWithProduct.append(category)
            }
        }
        print(categoryWithProduct)
        if categoryWithProduct.count > 0 {
            let subCategoryVC = SubCategoryVC(nibName: "SubCategoryVC", bundle: nil)
            subCategoryVC.arrSubcategories = categoryWithProduct
            self.parentContainerViewController()?.navigationController?.pushViewController(subCategoryVC, animated: true)
            
        } else {
            let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
            productsVC.fromCategory = true
            productsVC.categoryID = dict["banner_ad_cat_id"].intValue
            self.parentContainerViewController()?.navigationController?.pushViewController(productsVC, animated: true)
        }
        
        
//        let productsVC = ProductsVC(nibName: "ProductsVC", bundle: nil)
//        productsVC.fromCategory = true
//        productsVC.categoryID = arrBannersAd[indexPath.row]["banner_ad_cat_id"].intValue
//        self.parentContainerViewController()?.navigationController?.pushViewController(productsVC, animated: true)
//
        
    }
}
