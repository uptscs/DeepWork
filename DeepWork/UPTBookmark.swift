//
//  UPTBookmark.swift
//  DeepWork
//
//  Created by Upendra Tripathi on 3/27/19.
//  Copyright © 2019 Upendra Tripathi. All rights reserved.
//

import Foundation
import RealmSwift

class UPTBookmark: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var date = Date()
    convenience init(title: String, date:Date){
        self.init()
        self.title = title
        self.date = date
    }
}
