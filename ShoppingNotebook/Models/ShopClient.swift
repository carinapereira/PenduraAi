//
//  ShopClient.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 28/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import Foundation

class ShopClient{
    var key : String = ""
    var userKey : String = ""
    var shopKey : String = ""
    var name : String = ""
    var cpf : String = ""
    var phone : String = ""
    var creditLimit : Double = 0.0
    var urlImage : String = ""
    
    
    init (name : String, cpf : String, phone : String, creditLimit : Double, shopKey: String, userKey: String = "", urlImage : String = "", key: String = ""){
        self.key = key
        self.userKey = userKey
        self.shopKey = shopKey
        self.name = name
        self.cpf = cpf
        self.phone = phone
        self.creditLimit = creditLimit
        self.urlImage = urlImage
    }
    
    func toAnyObject() -> Any {
        return [
            "userKey": userKey,
            "shopKey": shopKey,
            "name": name,
            "cpf": cpf,
            "phone": phone,
            "creditLimit": creditLimit,
            "urlImage" : urlImage
        ]
    }
    
}

