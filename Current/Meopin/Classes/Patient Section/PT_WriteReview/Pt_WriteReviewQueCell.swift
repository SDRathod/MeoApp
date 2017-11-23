//
//  Pt_WriteReviewQueCell.swift
//  Meopin
//
//  Created by Tops on 11/7/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class Pt_WriteReviewQueCell: UITableViewCell {
    @IBOutlet var lblRWQueText: MDHTMLLabel!
    @IBOutlet var tpRatingView: TPFloatRatingView!
    @IBOutlet var btnCheckNoInfo: UIButton!
    @IBOutlet var lblRWAnswer: UILabel!
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        self.setControlProperties()
    }
    
    func setDeviceSpecificFonts() {
        lblRWQueText.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12.7))
        btnCheckNoInfo.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(13))
        lblRWAnswer.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(13))
    }
    
    func setControlProperties() {
        tpRatingView.emptySelectedImage = #imageLiteral(resourceName: "imgRate0")
        tpRatingView.fullSelectedImage = #imageLiteral(resourceName: "imgRate5")
        tpRatingView.maxRating = 5;
        tpRatingView.editable = true;
        tpRatingView.halfRatings = false;
        tpRatingView.floatRatings = false;
        
        lblRWQueText.linkAttributes = [NSForegroundColorAttributeName: Global.kAppColor.BlueLight, NSFontAttributeName: UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(15))!]
    }
}
