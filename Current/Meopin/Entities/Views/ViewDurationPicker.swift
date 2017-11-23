//
//  ViewTimePicker.swift
//  Booking_system
//
//  Created by Tops on 5/27/16.
//  Copyright © 2016 Tops. All rights reserved.
//

import UIKit

class ViewDurationPicker: UIView, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var btnDurationDone:UIButton!
    @IBOutlet weak var btnDurationCancel:UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var arrList:NSMutableArray!
    var is_showTitle = false
    override func awakeFromNib() {
      arrList  = NSMutableArray()
      ShowTitle(isShow: is_showTitle,text: "")
    }
    func ShowTitle(isShow:Bool,text:String) -> Void {
        is_showTitle = isShow
        if is_showTitle {
            lblTitle.isHidden = false            
            btnDurationCancel.isHidden = true
        }
        else{
            lblTitle.isHidden = true
            btnDurationCancel.isHidden = false
        }
        lblTitle.text = text
    }
    
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let Value = arrList[row] as! String
        return Value
    }
    
}
