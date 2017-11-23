//
//  CustomSlider.swift
//  Meopin
//
//  Created by Tops on 9/20/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 10.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {

       // self.setThumbImage(UIImage(named: "customThumb"), for: .Normal)
        super.awakeFromNib()
    }

}
