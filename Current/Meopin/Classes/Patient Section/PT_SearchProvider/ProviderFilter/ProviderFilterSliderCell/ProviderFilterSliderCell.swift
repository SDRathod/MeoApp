//
//  ProviderFilterSliderCell.swift
//  Meopin
//
//  Created by Tops on 9/15/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

protocol ProviderSliderDelegate {
    func locationSliderValueSelection(strDistance:String)
}

class ProviderFilterSliderCell: UITableViewCell {

    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var distanceSlider: CustomSlider!
    @IBOutlet weak var lbldistanceVal: UILabel!
    
    var delegate: ProviderSliderDelegate?
    var intMinValue = 0
    var intMaxValue = 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        lblDistance.text = Global().getLocalizeStr(key: "keyLocationDistance")
    let strVlaueSlider = Global.singleton.retriveFromUserDefaults(key: Global.kSearchFilterParamKey.Radius)
        distanceSlider.value = (strVlaueSlider! as NSString).floatValue
        self.lbldistanceVal.text = ("\(strVlaueSlider!) Km")
        setDeviceSpecificFonts()
    }
    func setDeviceSpecificFonts() {
        lblDistance.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
        lbldistanceVal.font = UIFont(name: Global.kFont.SourceRegular, size: Global.singleton.getDeviceSpecificFontSize(12))
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        self.lbldistanceVal.text = ("\(String(currentValue)) Km")
        self.delegate?.locationSliderValueSelection(strDistance: String(currentValue))
    }
}
