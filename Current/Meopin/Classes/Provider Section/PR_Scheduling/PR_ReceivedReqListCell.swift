//
//  PR_ReceivedReqListCell.swift
//  Meopin
//
//  Created by Tops on 10/16/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PR_ReceivedReqListCell: UITableViewCell {
    @IBOutlet var imgProPic: UIImageView!
    @IBOutlet var lblAppStatus: UILabel!
    @IBOutlet var lblPatientName: UILabel!
    @IBOutlet var lblAppReason: UILabel!
    @IBOutlet var btnArrow: UIButton!
    @IBOutlet var viewActions: UIView!
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet var btnReject: UIButton!
    @IBOutlet var btnModify: UIButton!
    @IBOutlet var btnViewDetail: UIButton!

    @IBOutlet weak var btnAcceptWidthConst: NSLayoutConstraint!
    @IBOutlet weak var btnRejectWidthConst: NSLayoutConstraint!
    @IBOutlet weak var btnModifyWidthConst: NSLayoutConstraint!
    @IBOutlet weak var btnViewDetailWidthConst: NSLayoutConstraint!
    
    // MARK: -  Set Language Titles & Device Specific Font Method
    func setLanguageTitles() {
        self.setDeviceSpecificFonts()
        
        btnAccept.setTitle(Global().getLocalizeStr(key: "keyPSAccept"), for: .normal)
        btnReject.setTitle(Global().getLocalizeStr(key: "keyPSReject"), for: .normal)
        btnModify.setTitle(Global().getLocalizeStr(key: "keyPSModify"), for: .normal)
        btnViewDetail.setTitle(Global().getLocalizeStr(key: "keyPSView"), for: .normal)
        
        self.setControlProperties()
    }
    
    func setDeviceSpecificFonts() {
        lblPatientName.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(10.8))
        lblAppReason.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(11))
        btnArrow.titleLabel?.font = UIFont(name: Global.kFont.MeopinTops, size: Global.singleton.getDeviceSpecificFontSize(6))
        btnAccept.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnReject.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnModify.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
        btnViewDetail.titleLabel?.font = UIFont(name: Global.kFont.SourceSemiBold, size: Global.singleton.getDeviceSpecificFontSize(12))
    }
    
    func setControlProperties() {
        imgProPic.layer.masksToBounds = true
        imgProPic.layer.cornerRadius = ((Global.singleton.getDeviceSpecificFontSize(47) - 15) / 2);
        imgProPic.layer.borderWidth = 0.5;
        imgProPic.layer.borderColor = imgProPic.backgroundColor?.cgColor
    }
}
