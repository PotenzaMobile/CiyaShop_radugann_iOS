//
//  VersionVC.swift
//  CiyaShop
//
//  Created by Rameshchandra Solanki on 26/07/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import Alamofire

//class VersionVC: UIViewController {
class VersionVC: UIView {

    //MARK:- outlet
    @IBOutlet weak var vwParent: UIView!
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var btnUpdate: UIButton!
    //@IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblVersion: UILabel!

    
    //MARK:- life cylce
    /*override func viewDidLoad() {
        super.viewDidLoad()
        showVersionPopUp()
        setUpUI()

    }*/
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showVersionPopUp()
        setUpUI()
    }
    
    func showVersionPopUp()
    {
        VersionCheck.shared.checkAppStore() { isNew, version in
                print("IS NEW VERSION AVAILABLE: \(isNew), APP STORE VERSION: \(version)")
            }
    }
    func setUpUI()
    {
        self.vwParent.layer.borderWidth = 0.5
        self.vwParent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwParent.cornerRadius(radius: 5)
        
        
        vwHeader.clipsToBounds = true
        vwHeader.backgroundColor = secondaryColor
        
        lblHeading.textColor = .white
        lblHeading.font = UIFont.appBoldFontName(size: fontSize16)
        
        lblVersion.textColor = .black
        lblVersion.font = UIFont.appRegularFontName(size: fontSize12)
        
        [btnUpdate].forEach { (button) in
            button?.titleLabel?.font = UIFont.appBoldFontName(size: fontSize14)
            button?.setTitleColor(.white, for: .normal)
            button?.backgroundColor = secondaryColor
        }
    }
    //MARK:-
    func dismissView() {
        self.removeFromSuperview()
    }
    //MARK:-
    @IBAction func btnUpdateAction(_ sender: Any) {
        
        if let url = URL(string: "itms-apps://apple.com/app/id1600061842") {
            UIApplication.shared.open(url)
            
        }else{
            print("App store can not be open")
//            showToast(message: "App store can not be open")
        }
        
    }
    
//    @IBAction func btnCancelAction(_ sender: Any) {
////        self.dismiss(animated: true, completion: nil)
//        dismissView()
//    }
//
    
}
class VersionCheck {

    public static let shared = VersionCheck()

    var newVersionAvailable: Bool?
    var appStoreVersion: String?

    func checkAppStore(callback: ((_ versionAvailable: Bool?, _ version: String?)->Void)? = nil) {
        let ourBundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(ourBundleId)").responseJSON { response in
            var isNew: Bool?
            var versionStr: String?

            if let json = response.result.value as? NSDictionary,
               let results = json["results"] as? NSArray,
               let entry = results.firstObject as? NSDictionary,
               let appVersion = entry["version"] as? String,
               let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            {
                isNew = ourVersion != appVersion
                versionStr = appVersion
            }

            self.appStoreVersion = versionStr
            self.newVersionAvailable = isNew
            callback?(isNew, versionStr)
        }
    }
}
