//
//  ProviderFilterRatingCell.swift
//  Meopin
//
//  Created by Tops on 9/15/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import Cosmos

protocol ProviderFilterRatingCellDelegate {
    func didEndTouchingRatingCallMethod(strRatings:String, cell: ProviderFilterRatingCell)
}
class ProviderFilterRatingCell: UITableViewCell {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblRatCoubt: UILabel!
    
    var delegate: ProviderFilterRatingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.didTouchCosmos = didTouchCosmos
        ratingView.didFinishTouchingCosmos = didFinishTouchingCosmos
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        //ratingView.rating = CurrentRating
        setDeviceSpecificFonts()
    }
    
    func setDeviceSpecificFonts() {
        lblRate.text = Global().getLocalizeStr(key: "keyGlobalRating")

        lblRate.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblRatCoubt.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))

    }
    func formatValue(_ value: Double) -> String {
        return String(format: "%d",Int(value))
    }
    
    func didTouchCosmos(_ rating: Double) {
        if rating > 0.5 {
         lblRatCoubt.text = ("\(Int(rating))/5")
        } else {
            lblRatCoubt.text = ""
        }
        
    }
    
    func didFinishTouchingCosmos(_ rating: Double) {
        if rating > 0.5 {
            Global.singleton.saveToUserDefaults(value: formatValue(rating), forKey: Global.kSearchFilterParamKey.Rating)
        } else {
            Global.singleton.saveToUserDefaults(value: formatValue(0), forKey: Global.kSearchFilterParamKey.Rating)

        }
        self.delegate?.didEndTouchingRatingCallMethod(strRatings: formatValue(rating), cell: self)
    }
}
