//
//  sharedBlogCategory.swift
//  Meopin
//
//  Created by Chirag Patel on 11/7/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class sharedBlogCategory: NSObject {
    var strDiscription: String = ""
    var strCategoryId: String = ""
    var strCategoryImage: String = ""
    var strCategoryName: String = ""
    var strCategorySlug: String = ""
    var strCategoryLink: String = ""

}


class sharedMostViewedBlogPost: NSObject {
    var strId: String = ""
    var strPerLink: String = ""
    var strTitle: String = ""
    var strContent: String = ""
    
    var strMediaId : String = ""
    var strFullImage: String = ""
    var strThumbImage: String = ""
    var strCategoryName: String = ""
    
    var strAuthorName: String = ""
    var strTotalPostCount: String = ""
    var strDate: String = ""
    var strViewPost: String = ""
}
