//
//  PT_InboxTableCell.swift
//  Meopin
//
//  Created by Chirag Patel on 11/7/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PT_InboxTableCell: UITableViewCell {

    @IBOutlet weak var lblNotiTTFIcon: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.setFontDeviceSpecific()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
       
    }
    
    func setFontDeviceSpecific() {
        lblMessage.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
        lblDate.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(11))
    }
    
}
