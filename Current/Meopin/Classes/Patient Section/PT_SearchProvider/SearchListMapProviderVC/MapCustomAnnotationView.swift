//
//  MapCustomAnnotationView.swift
//  Meopin
//
//  Created by Tops on 9/28/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class MapCustomAnnotationView: UIView {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var shadowView: UIView!
  
    
    func shadowBottomLable() {
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1.5)
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowColor  = Global().RGB(r: 227.0, g: 227.0, b: 227.0, a: 1).cgColor
        shadowView.layer.shadowRadius = 1.0
        shadowView.layer.borderWidth = 0.2
        shadowView.layer.borderColor = Global().RGB(r: 179.0, g: 179.0, b: 179.0, a: 0.5).cgColor
        shadowView.layer.cornerRadius = 2
        shadowView.alpha = 1
    }
}
