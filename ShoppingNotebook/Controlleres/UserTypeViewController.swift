//
//  UserTypeViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 18/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit

class UserTypeViewController: UIViewController {

    @IBOutlet weak var btClient: UIButton!
    @IBOutlet weak var btTrader: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btClient.layer.cornerRadius = 5
        btTrader.layer.cornerRadius = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueTrader"{
            let vc = segue.destination as! SingUpViewController
            vc.typeOfUser = "Comerciante"
        }
    }

}
