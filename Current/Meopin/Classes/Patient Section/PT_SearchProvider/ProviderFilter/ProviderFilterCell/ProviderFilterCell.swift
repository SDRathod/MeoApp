//
//  providerSearchCell.swift
//  Meopin
//
//  Created by Tops on 9/13/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

protocol FilterCellDelegate {
    func fiilterDropDownClickDelegate(cell: ProviderFilterCell)
}
class ProviderFilterCell: UITableViewCell {
    @IBOutlet weak var txtSpokenLang: UITextField!
    @IBOutlet weak var txtHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var lblProviderQuest: UILabel!
    @IBOutlet weak var lblProviderType: UILabel!
    @IBOutlet weak var btnDropDown: UIButton!
    var delegate: FilterCellDelegate?
    
    @IBOutlet weak var lblArrow: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setDeviceSpecificFonts()

    }
    func setDeviceSpecificFonts() {
        lblProviderQuest.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        lblProviderType.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))

    }
    
    // MARK: -  ALL btnDropDownClickTapped Method Start
    @IBAction func btnDropDownClickTapped(sender: AnyObject){
        if let _ = delegate {
            delegate?.fiilterDropDownClickDelegate(cell: self)
        }
    }
}
