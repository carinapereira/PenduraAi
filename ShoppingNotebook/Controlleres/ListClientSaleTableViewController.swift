//
//  ListClientSaleTableViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 01/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ListClientSaleTableViewController: UITableViewController {
    
    var ref:FIRDatabaseReference!
    var refShop: FIRDatabaseReference!
    var refShopValue: FIRDatabaseReference!
    var items:[[String:Any]] = []
    var images:NSArray?
    var dic:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bundlePath = Bundle.main.path(forResource: "imagens", ofType: "plist"){
            if let dicionario = NSDictionary(contentsOfFile: bundlePath) {
                images = dicionario["images"] as? NSArray
                dic = images?[0] as? NSDictionary
            }
        }
   
        if let user = FIRAuth.auth()?.currentUser {
            var shopKey : String = ""
            
            refShop = FIRDatabase.database().reference().child("shop")
            refShop.queryOrdered(byChild: "userKey").queryEqual(toValue: user.uid).observe(.value){ (snapshot:FIRDataSnapshot) in
                
                let enumerator = snapshot.children
                while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                    shopKey = item.key as String
                }
                
                if shopKey != "" {
                    self.ref = FIRDatabase.database().reference().child("shopClient")
                    self.startingObserveDB(shopKey: shopKey)
                }
            }
        }
    }

    func startingObserveDB(shopKey: String) {
        ref.queryOrdered(byChild: "shopKey").queryEqual(toValue: shopKey).observe(.value) { (snapshot:FIRDataSnapshot) in
            var temp: [[String:Any]] = []
            let enumerator = snapshot.children
            while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                var dic = item.value as! [String: Any]
                dic["key"] = item.key
                temp.append(dic)
            }
            self.items = temp
            self.tableView.reloadData()
        }
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vendaCell", for: indexPath) as! ListClienteSaleTableViewCell
        
        let item = items[indexPath.row]
        cell.lbNome.text = item["name"] as? String
        cell.lbFone.text = item["phone"] as? String
        if let credito = item["creditLimit"] as? Double {
            cell.lbTotal.text = "\(credito)"
        }
        if let imageUrl = item["urlImage"] as? String{
            if imageUrl != "" {
                cell.imgView.loadImageWithCache(imageUrl)
            }else{
                cell.imgView.image = UIImage(named: dic?["withoutPhoto"] as! String)
            }
        }
      
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueAddValue", let index = tableView.indexPathForSelectedRow {
            let detailVC = segue.destination as! AddValueViewController
            var dic = self.items[index.row]
            detailVC.key = dic["key"] as? String
        }
    }
}
