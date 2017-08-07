//
//  Shop.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 18/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import Foundation
import FirebaseAuth

class Shop {
    var key : String = ""
    var userKey : String = ""
    var name : String = ""
    var cpjCnpj : String = ""
    var phone : String = ""
    
    init(name : String, cpjCnpj : String, phone : String, userKey : String = "", key : String = "" ){
        self.key = key
        self.userKey = userKey
        self.name = name
        self.cpjCnpj = cpjCnpj
        self.phone = phone
    }
    
    func toAnyObject() -> Any {
        return [
            "userKey": userKey,
            "name": name,
            "cpjCnpj": cpjCnpj,
            "phone": phone
        ]
    }
}
