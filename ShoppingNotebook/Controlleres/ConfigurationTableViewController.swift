//
//  ConfigurationTableViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 28/11/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ConfigurationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
   
    @IBAction func btLogout(_ sender: UIButton) {
        try! FIRAuth.auth()?.signOut()
        
        if let tabBar = tabBarController {
            tabBar.selectedIndex = 0
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = FIRAuth.auth()?.currentUser {
            if let navigation = self.navigationController{
                if indexPath.row == 0 {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "singUpViewControllerID") as! SingUpViewController
                    vc.edit = true
                    navigation.pushViewController(vc, animated: true)
                }
        
                if indexPath.row == 1 {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shopViewControllerId") as! ShopViewController
                    vc.user = User(authData: user)
                    vc.edit = true
                    navigation.pushViewController(vc, animated: true)
                }
            }else{
                Alert(controller: self).showErro()
            }
        }
    }
}
