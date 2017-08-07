//
//  UserTransactionsViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 08/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit

class UserTransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbTotal: UILabel!

    var valores :[[String]] = [["05/12/2016", "RS 25,00"],["08/12/2016", "RS 87,00"],["10/12/2016", "RS 12,00"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        lbNome.text = "Grazi Massafera"
     
        lbTotal.text = "Total    R$ 124,00"
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "valoresCell", for: indexPath) as! UserTransactionsTableViewCell
        
        let item = valores[indexPath.row]
        cell.lbData.text = item[1]
        cell.lbValor.text = item[0]
       
        
        return cell
    
    }
    
    


}
