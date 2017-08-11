//
//  Property.swift
//  GoldenTime
//
//  Created by ramy nasser on 7/8/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import Foundation

struct Property {
    
    var id: Int
    var name : String
    var unit_id: Int
    var unit_type : String
    var class_type : String
    var area: String
    var address :String
    var notes:String
    var rented : Int
    var rentable: Int
    var top_level: Int
    var parent_property_id: Int
    var owner_id: Int
    var photos :[Photos]
    var details :[Details]


}
