//
//  ListClientTableViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 28/11/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ListClientTableViewController: UITableViewController, UISearchControllerDelegate,UISearchBarDelegate  {
    
    var ref:FIRDatabaseReference!
    var refShop:FIRDatabaseReference!
    var refDelete:FIRDatabaseReference!
    var items:[[String:Any]] = []
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        refShop = FIRDatabase.database().reference().child("shop")
    }
    
    func checkLogin(){
        if let user = FIRAuth.auth()?.currentUser {
            var shopKey : String = ""
            
            refShop.queryOrdered(byChild: "userKey").queryEqual(toValue: user.uid).observe(.value) { (snapshot:FIRDataSnapshot) in
                
                let enumerator = snapshot.children
                while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                    shopKey = item.key as String
                }
                
                if shopKey != "" {
                    self.ref = FIRDatabase.database().reference().child("shopClient")
                    self.startingObserveDB(shopView: shopKey)
                }
            }
        }
        else {
            performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    func startingObserveDB(shopView : String) {
        ref.queryOrdered(byChild: "shopKey").queryEqual(toValue: shopView).observe(.value) { (snapshot:FIRDataSnapshot) in
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkLogin()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      /*  if let city = searchBar.text{
            getStationServiceByCity(city: city)
        }*/
    }
    
    func createSearchBarController(){
        
        self.searchController = UISearchController(searchResultsController: nil)
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath) as! ListClientTableViewCell
        
        let item = items[indexPath.row]
        cell.lbNome.text = item["name"] as? String
        cell.lbTelefone.text = item["phone"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            var dic = items[indexPath.row]
            refDelete = FIRDatabase.database().reference().child("shopClient").child(dic["key"] as! String )
            refDelete.removeValue()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEdit", let index = tableView.indexPathForSelectedRow {
            let detailVC = segue.destination as! NewClienteViewController
            var dic = self.items[index.row]
            detailVC.key = dic["key"] as? String
        }
    }
  
}
