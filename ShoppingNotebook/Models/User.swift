//
//  User.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 22/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//


import Foundation
import FirebaseAuth

class User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
