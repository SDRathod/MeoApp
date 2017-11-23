//
//  HomeCell.swift
//  Meopin
//
//  Created by Tops on 8/30/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    @IBOutlet var lblIconOpt: UILabel!
    @IBOutlet var lblTitleOpt: UILabel!
    @IBOutlet var lblSubTitleOpt: UILabel!
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        lblIconOpt.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(26))
        lblTitleOpt.font = UIFont(name: Global.kFont.SourceBold, size: Global.singleton.getDeviceSpecificFontSize(16.5))
        lblSubTitleOpt.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11.5))
    }
}
