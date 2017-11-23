//
//  CalendarAgendaViewCell.swift
//  Meopin
//
//  Created by Tops on 10/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class CalendarAgendaViewCell: UITableViewCell {
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAppReason: UILabel!
    @IBOutlet var lblStatusColor: UILabel!
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        lblStartTime.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblEndTime.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblTitle.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblAppReason.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
    }
}
