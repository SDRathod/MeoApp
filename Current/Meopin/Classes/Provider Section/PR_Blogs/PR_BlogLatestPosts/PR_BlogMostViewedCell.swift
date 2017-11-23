//
//  PR_BlogMostViewedCell.swift
//  Meopin
//
//  Created by Tops on 11/10/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PR_BlogMostViewedCell: UITableViewCell {
    
    @IBOutlet weak var lblAuthorName: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblPostView: UILabel!
    @IBOutlet weak var lblCommentTTF: UILabel!
    @IBOutlet weak var lblPostViewTTF: UILabel!

    @IBOutlet weak var btnCategoryName: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnCategoryName.layer.cornerRadius = 5
        self.setDeviceSpecificFont()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDeviceSpecificFont() {
        btnCategoryName.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblAuthorName.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9))
        lblDiscription.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblCommentCount.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9))
        lblPostView.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9))
        lblCommentTTF.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(10))
        lblPostViewTTF.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(7))
        lblDate.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(9))
        
    }

}
