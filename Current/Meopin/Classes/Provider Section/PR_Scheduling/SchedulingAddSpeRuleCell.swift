//
//  SchedulingAddSpeRuleCell.swift
//  Meopin
//
//  Created by Tops on 9/26/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingAddSpeRuleCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblArrow: UILabel!

    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        lblTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblValue.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblArrow.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(10))
    }
}
