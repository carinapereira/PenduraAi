//
//  Purchase.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 18/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import Foundation

class Purchase {
    var key : String
    var value : Double
    var date : String
    var time : String
    var sum : Bool
    
    init(value : Double, date: String, time: String, sum : Bool, key: String = ""){
        self.key = key
        self.value = value
        self.date = date
        self.time = time
        self.sum = sum
    }
    
    func toAnyObject() -> Any {
        return [
            "value": value,
            "date": date,
            "time": time,
            "sum": sum
        ]
    }
}

