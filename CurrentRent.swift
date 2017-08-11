//
//  currentRent.swift
//  GoldenTime
//
//  Created by ramy nasser on 7/20/17.
//  Copyright © 2017 RamyNasser. All rights reserved.
//

import Foundation

struct CurrentRent {
   var id: Int?
   var renter_name:String?
   var start_date:String?
   var end_date:String?
    var type :String?
     var value:Int?
    var is_current:Int?
    var property_id:Int
//    "case": [],
    var photos: [Photos]?
    var collections:[Collection]
}
