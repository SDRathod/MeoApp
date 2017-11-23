//
//  PT_MyReviewsCell.swift
//  Meopin
//
//  Created by Tops on 11/11/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PT_MyReviewsCell: UITableViewCell {
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblReviewTime: UILabel!
    @IBOutlet var lblReviewDesc: UILabel!
    @IBOutlet var lblReviewAllRating: UILabel!
    @IBOutlet var lblReviewRating: UILabel!
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        self.setControlProperties()
    }
    
    func setDeviceSpecificFonts() {
        lblUserName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblReviewTime.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblReviewDesc.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblReviewRating.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblReviewAllRating.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(8.8))
    }
    
    func setControlProperties() {
        imgProfilePic.layer.masksToBounds = true
        imgProfilePic.layer.cornerRadius = ((Global.screenWidth * 35) / 320) / 2
        imgProfilePic.layer.borderWidth = 0.5
        imgProfilePic.layer.borderColor = Global().RGB(r: 210, g: 210, b: 210, a: 1).cgColor
    }
}
