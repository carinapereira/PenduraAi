//
//  Alert.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 27/11/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    let controller:UIViewController
    
    init(controller:UIViewController){
        self.controller = controller
    }
    
    func showErro(message:String = "Unexpected error. Be careful") {
        let alert = UIAlertController(title: "Desculpa", message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showSucesso(message:String = "Sucesso !") {
        let alert = UIAlertController(title: "Informação", message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
}
