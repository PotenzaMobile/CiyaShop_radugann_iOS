//
//  NotesTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 05/10/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotesTableViewCell: UITableViewCell {

    //MARK:- Outlet
    @IBOutlet weak var vwNotes: UIView!
    @IBOutlet weak var vwNotesContent: UIView!

    @IBOutlet weak var lblNotesHeading: UILabel!
    @IBOutlet weak var txtNotes: UITextField!
    
    //MARK:- variable
    var dictDetails = JSON()
    var handlerNotes : (String)->Void = {_ in}

    //MARK:- Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtNotes.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
        setUpUI()
    }
    func setUpUI()
    {
        
        self.vwNotes.backgroundColor = .white
        self.vwNotes.layer.borderWidth = 0.5
        self.vwNotes.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.35).cgColor
        self.vwNotes.cornerRadius(radius: 5)
        
        self.vwNotesContent.backgroundColor = .white
        self.vwNotesContent.layer.borderWidth = 0.5
        self.vwNotesContent.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.vwNotesContent.cornerRadius(radius: 5)

        
        lblNotesHeading.text = MCLocalization.string(for: "Notes")
        lblNotesHeading.textColor = secondaryColor
        lblNotesHeading.font = UIFont.appBoldFontName(size: fontSize14)

        txtNotes.font = UIFont.appBoldFontName(size: fontSize12)
        txtNotes.textColor = normalTextColor
        txtNotes.placeholder = MCLocalization.string(for: "EnterNotes")
    }

    func setUpData()
    {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK:- Textfield methods
extension NotesTableViewCell : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.contentView.resignFirstResponder()
        return true
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        handlerNotes(textField.text!)
        
    }
}
