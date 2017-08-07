//
//  ListShopTableViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 28/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import Firebase

class ListShopTableViewController: UITableViewController {
    var ref : FIRDatabaseReference!
    var items : [[String:String]] = []

    override func viewDidDisappear(_ animated: Bool) {
        try! FIRAuth.auth()?.signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var isAnonymous = false
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            isAnonymous = user!.isAnonymous
            //let userID = user!.uid
            
            if isAnonymous {
                self.ref = FIRDatabase.database().reference().child("shop")
                self.startingObserveDB()
            }
            else {
                Alert(controller: self).showErro(message: "Não foi possível conectar com o Firebase!")
            }
        }
    }
    
    func startingObserveDB() {
        ref.observe(.value) { (snapshot:FIRDataSnapshot) in
            var temp: [[String:String]] = []
            let enumerator = snapshot.children
            while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                
                var dic = item.value as! [String: String]
                dic["key"] = item.key
                temp.append(dic)
            }
            self.items = temp
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ListShopTableViewCell
        
        let item = items[indexPath.row]
        cell.lbCompany.text = item["name"]
        cell.lbPhone.text = item["phone"]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Alert(controller: self).showSucesso(message: "Entre em contato com este estabelecimento e faça seu cadastro. Após você poderá acompanhar a movimentação de suas compras em tempo real. Não perca tempo! Comece hoje a controlar melhor seus gastos.")
    }

}
