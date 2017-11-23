//
//  ProviderDetailCell.swift
//  Meopin
//
//  Created by Tops on 9/27/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class ProviderDetailCell: UITableViewCell {

    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lbldiscription: UILabel!
    @IBOutlet weak var lblproviderTime: UILabel!
    @IBOutlet weak var lblproviderName: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.providerImageBorderSet()
        setFontProperty()
    }
    
    func providerImageBorderSet() {
        ProfileImage.layer.borderWidth = 1.4
        ProfileImage.layer.borderColor = Global().RGB(r: 179.0, g: 179.0, b: 179.0, a: 0.5).cgColor
        ProfileImage.layer.cornerRadius = 5
    }
    
    func setFontProperty()  {
        lblproviderName.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        lbldiscription.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblScore.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblproviderTime.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(8))
        
    }
}
