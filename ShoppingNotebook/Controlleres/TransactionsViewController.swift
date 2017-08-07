//
//  TransactionsViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 04/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import Firebase

class TransactionsViewController: UIViewController {

    @IBOutlet weak var btGrafico: UIButton!
    @IBOutlet weak var lbMes: UILabel!
    @IBOutlet weak var lbTotalHoje: UILabel!
    @IBOutlet weak var lbTotalMes: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    
    var ref: FIRDatabaseReference!
    var refShop:FIRDatabaseReference!
    var refValues:FIRDatabaseReference!
    var refer : FIRDatabaseReference!
    var dataSelecionada = ""
    var keys:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        lbMes.text = dataSelecionada
        
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
        var total = 0.0
        var totalPaid = 0.0
        var totalDay = 0.0
        var totalMonth = 0.0
        
        self.lbTotalHoje.text = "Hoje: R$: \(totalDay)"
        self.lbTotalMes.text = "Mês: R$: \(total)"
        self.lbTotal.text = "Pendente: R$: \(total - totalPaid)"
        
        ref.queryOrdered(byChild: "shopKey").queryEqual(toValue: shopKey).observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let result = snapShot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    if let result2 = child.childSnapshot(forPath: "shopClientValue").children.allObjects as? [FIRDataSnapshot] {
                        for child2 in result2 {
                            print(child2.key)
                            var dic = child2.value as! [String: Any]
                            let day = dic["date"] as? String
                            
                            if let sum = dic["sum"] as? Bool {
                                if let valor = dic["value"] as? Double {
                                    if sum {
                                        total += valor
                                        
                                        if day == self.dataSelecionada {
                                            totalDay += valor
                                        }
                                        
                                        if let dia = day {
                                            let dataMov = Date().toDate(data: dia)
                                            let dataSel  = Date().toDate(data: self.dataSelecionada)
                                            if Date().month(data: dataMov) == Date().month(data: dataSel){
                                                totalMonth += valor
                                            }
                                        }
                                    }else{
                                        totalPaid += valor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.lbTotalHoje.text = "Hoje: R$: \(totalDay)"
            self.lbTotalMes.text = "Mês: R$: \(totalMonth)"
            self.lbTotal.text = "Pendente: R$: \(total - totalPaid)"
        })
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueGrafico" {
            let view = segue.destination as! ChartViewController
            view.dataSelecionada = dataSelecionada
        }else{
            Alert(controller: self).showErro()
        }
    }
    
}







