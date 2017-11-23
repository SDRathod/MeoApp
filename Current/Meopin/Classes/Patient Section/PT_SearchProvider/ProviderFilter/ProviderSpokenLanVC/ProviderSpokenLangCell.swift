//
//  ProviderSpokenLangCell.swift
//  Meopin
//
//  Created by Tops on 9/26/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
protocol ProviderSpokenLangDelegate {
    func providerSpokenLanguageDropDownClickDelegate(strText: String,cell: ProviderSpokenLangCell)
}

class ProviderSpokenLangCell: UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var txtSpokenLang: UITextField!
    @IBOutlet weak var lblSpokenLang: UILabel!
    var delegate: ProviderSpokenLangDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setDeviceSpecificFonts()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.txtSpokenLang.layer.masksToBounds = true
        self.txtSpokenLang.layer.cornerRadius = 2.0
        self.txtSpokenLang.layer.borderColor = Global.kTextFieldProperties.BorderColor
        self.txtSpokenLang.layer.borderWidth = 0.4
        self.txtSpokenLang.paddingviewWithCustomValue(12.0, txtfield: self.txtSpokenLang)
    }
    
    func setDeviceSpecificFonts() {
        lblSpokenLang.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        txtSpokenLang.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))

    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.delegate?.providerSpokenLanguageDropDownClickDelegate(strText: textField.text ?? "", cell: self)
        return true
    }
}

