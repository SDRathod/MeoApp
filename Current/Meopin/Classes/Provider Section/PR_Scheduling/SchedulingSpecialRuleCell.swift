//
//  SchedulingSpecialRuleCell.swift
//  Meopin
//
//  Created by Tops on 9/26/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingSpecialRuleCell: UITableViewCell {
    @IBOutlet var viewCellBg: UIView!
    @IBOutlet var lblRuleTitle: UILabel!
    @IBOutlet var lblRuleType: UILabel!
    @IBOutlet var lblRuleDetail: UILabel!
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        self.setControlProperties()
    }
    
    func setDeviceSpecificFonts() {
        lblRuleTitle.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblRuleType.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(15))
        lblRuleDetail.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11.3))
    }
    
    func setControlProperties() {
        viewCellBg.layer.masksToBounds = true
        viewCellBg.layer.cornerRadius = 6.0
    }
}
