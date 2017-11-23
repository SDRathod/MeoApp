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

    @IBOutlet weak var lblRecomondation: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var lblSpecialits: UILabel!
    @IBOutlet weak var lblProviderName: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
