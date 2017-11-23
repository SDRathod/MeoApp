//
//  SchedulingOnLeaveCell.swift
//  Meopin
//
//  Created by Tops on 9/22/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingOnLeaveCell: UITableViewCell {
    @IBOutlet var viewCellBg: UIView!
    @IBOutlet var lblStartEndDate: UILabel!
    @IBOutlet var lblTotDays: UILabel!
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        self.setControlProperties()
    }
    
    func setDeviceSpecificFonts() {
        lblStartEndDate.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11.3))
        lblTotDays.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(15))
    }
    
    func setControlProperties() {
        viewCellBg.layer.masksToBounds = true
        viewCellBg.layer.cornerRadius = 6.0
    }
}
