//
//  PT_ReviewDetailCell.swift
//  Meopin
//
//  Created by Tops on 11/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PT_ReviewDetailCell: UITableViewCell {
    @IBOutlet weak var lblRevQues: UILabel!
    @IBOutlet weak var lblRevAns: UILabel!

    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        lblRevQues.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.7))
        lblRevAns.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
}
