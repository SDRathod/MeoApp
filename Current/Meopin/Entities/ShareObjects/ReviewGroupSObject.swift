//
//  ReviewGroupSObject.swift
//  Meopin
//
//  Created by Tops on 11/7/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class ReviewGroupSObject: NSObject {
    var strRWGroupId: String = ""
    var strRWGroupTitle: String = ""
    var strRWGroupLikeText: String = ""
    var strRwGroupRating: String = ""
    var arrRWGroupQueList: [ReviewQueSObject] = [ReviewQueSObject]()
}
