//
//  UPTActivity.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/26/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import Foundation
import RealmSwift

class UPTActivity: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var startDateTime = Date()
    @objc dynamic var endDateTime = Date()
//    @objc dynamic var feedback = UPTActivityFeedback()
    
    convenience init(name: String, startDate: Date, endDate: Date) {
        self.init()
        self.name = name
        self.startDateTime = startDate
        self.endDateTime = endDate
    }
    
}

class UPTActivityFeedback: Object{
    @objc dynamic var id = UUID().uuidString
    // TODO: Would love to store the enum directly, without following workaround:
    // @objc dynamic var type = UPTFeedbackType.None
    // Ref: https://medium.com/it-works-locally/persisting-swift-enumerations-with-realm-io-dab37cd98bcd
    @objc private dynamic var feedbackType: String = UPTFeedbackType.None.rawValue
    var type: UPTFeedbackType {
        get { return UPTFeedbackType(rawValue: feedbackType)! }
        set { feedbackType = newValue.rawValue }
    }
    @objc dynamic var note = ""
}

enum UPTFeedbackType:String {
    case None
    case Shallow
    case Deep
}
