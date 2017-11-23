//
//  ReviewSObject.swift
//  Meopin
//
//  Created by Tops on 11/7/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit

class ReviewSObject: NSObject {
    var strReviewId: String = ""
    var strReviewProviderId: String = ""
    var strReviewPatientId: String = ""
    var strReviewTitle: String = ""
    var strReviewFeedback: String = ""
    var strReviewVisitDate: String = ""
    var strReviewGlobalRating: String = ""
    var arrReviewGroupList: [ReviewGroupSObject] = [ReviewGroupSObject]()
}
