//
//  SearchProviderTableCell.swift
//  Meopin
//
//  Created by Tops on 9/19/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class SearchProviderTableCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblRecomondation: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var lblSpecialits: UILabel!
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.providerImageBorderSet()
        setFontProperty()
    }
    
    func providerImageBorderSet() {
        profileView.layer.borderWidth = 1.4
        profileView.layer.borderColor = Global().RGB(r: 179.0, g: 179.0, b: 179.0, a: 0.5).cgColor
        profileView.layer.cornerRadius = 5
        lblRatingCount.layer.cornerRadius = lblRatingCount.frame.size.height / 2
    }
    
    func setFontProperty()  {
        lblAddress.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblDistance.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblProviderName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblSpecialits.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblRecomondation.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        
    }
}
