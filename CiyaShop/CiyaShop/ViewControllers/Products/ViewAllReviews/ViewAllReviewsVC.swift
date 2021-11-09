//
//  ViewAllReviewsVC.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 16/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewAllReviewsVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var tblReviews: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!

    //MARK:-Variables
    var arrayReviews : [JSON] = []
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    //MARK:- Setup UI
    func setUpUI()
    {
        // Initialization code
        
        self.view.setBackgroundColor()
        
        registerDatasourceCell()
        btnBack.tintColor =  secondaryColor

        
        lblTitle.text = getLocalizationString(key: "Reviews")
        lblTitle.font = UIFont.appBoldFontName(size: fontSize16)
        lblTitle.textColor = secondaryColor
        //--
        
    }
    // MARK: - Cell Register
    func registerDatasourceCell()
    {
        
        tblReviews.delegate = self
        tblReviews.dataSource = self
        
        tblReviews.setBackgroundColor()
        
        tblReviews.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK:-  UITableview Delegate Datasource
extension ViewAllReviewsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayReviews.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        
        let dict = arrayReviews[indexPath.row]
        
        cell.setUpReviewData(dict:dict)
        
        return cell
    }
    
}
