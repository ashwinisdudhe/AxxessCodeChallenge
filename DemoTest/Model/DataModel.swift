//
//  DataModel.swift
//  TestDemo
//
//  Created by Ashwini.Dudhe on 22/07/20.
//  Copyright © 2020 Ashwini.Dudhe. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DataModel: Object, Codable {
    
    dynamic var id: String?
    dynamic var type: String?
    dynamic var date: String?
    dynamic var data: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case date = "date"
        case data = "data"
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init()
    {
        super.init()
    }
}
