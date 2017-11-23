//
//  SchedulingConfigCell.swift
//  Meopin
//
//  Created by Tops on 9/18/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SchedulingConfigCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnValue: UIButton!
    @IBOutlet var btnArrow: UIButton!
    @IBOutlet var btnSelected: UIButton!
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        lblTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13.1))
        btnValue.titleLabel?.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
        btnArrow.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(8))
        btnSelected.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(10))
    }
}
