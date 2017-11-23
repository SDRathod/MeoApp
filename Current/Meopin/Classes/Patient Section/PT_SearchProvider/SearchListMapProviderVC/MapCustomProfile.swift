//
//  MapCustomAnnotationView.swift
//  Meopin
//
//  Created by Tops on 9/28/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class MapCustomProfile: UIView {
    @IBOutlet weak var profileImage: UIImageView!

    func cornerReduce() {
        profileImage.layer.cornerRadius = (profileImage.frame.height) / 2
        profileImage.layer.masksToBounds = true
        profileImage.clipsToBounds = true
    }
    
}
