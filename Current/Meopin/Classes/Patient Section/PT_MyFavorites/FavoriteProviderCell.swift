//
//  FavoriteProviderCell.swift
//  Meopin
//
//  Created by Tops on 10/9/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class FavoriteProviderCell: UITableViewCell {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblRatingScore: UILabel!
    
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnFavoraite: UIButton!

    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var lblRecomondation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.providerImageBorderSet()
        setFontProperty()
    }
    
    func providerImageBorderSet() {
        profileImage.layer.cornerRadius = 5
        lblRatingScore.layer.cornerRadius = lblRatingScore.frame.size.height / 2
        profileView.layer.borderWidth = 1.4
        profileView.layer.borderColor = Global().RGB(r: 179.0, g: 179.0, b: 179.0, a: 0.5).cgColor
        profileView.layer.cornerRadius = 5
        btnFavoraite.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(14))

    }
    
    func setFontProperty(){
        lblAddress.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblDistance.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(8))
        lblProviderName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblSpeciality.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblRecomondation.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblRatingScore.layer.cornerRadius = lblRatingScore.frame.size.height / 2
    }
}
