//
//  PR_BlogListCell.swift
//  Meopin
//
//  Created by Tops on 11/2/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class PR_CategoryList: UITableViewCell {

    @IBOutlet var lblCategoryName: UILabel!
    @IBOutlet var imgCategory: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setDeviceSpecificationFont()
    }
    
    func setDeviceSpecificationFont() {
        lblCategoryName.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(14))
    }
}
