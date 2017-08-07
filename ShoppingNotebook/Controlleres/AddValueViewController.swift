//
//  ClientViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 29/11/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import Firebase

class AddValueViewController: UIViewController {

    @IBOutlet weak var tfValor: UITextField!
    @IBOutlet weak var scSoma: UISegmentedControl!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbTotalPurchase: UILabel!
    @IBOutlet weak var lbCreditLimit: UILabel!
    @IBOutlet weak var btPaymenthistory: UIButton!
    
    var ref:FIRDatabaseReference!
    var refValor:FIRDatabaseReference!
    var key:String?
    var userKey:String?
    var dicImage:NSDictionary?
    var images:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpComponentsConfiguration()
        
        if let bundlePath = Bundle.main.path(forResource: "imagens", ofType: "plist"){
            if let dicionario = NSDictionary(contentsOfFile: bundlePath) {
                images = dicionario["images"] as? NSArray
                dicImage = images?[0] as? NSDictionary
            }
        }
        
        self.lbDate.text = Date().Atual()
        
        if let key = key {
            ref = FIRDatabase.database().reference().child("shopClient").child(key)
            ref.observeSingleEvent(of: .value, with: { (snapShot) in
                
                var dic = snapShot.value as! [String: Any]
                self.lbNome.text = dic["name"] as? String
                self.userKey = dic["userKey"] as? String
                
                self.lbCreditLimit.text = "Limite de Crédito: R$: 0.0"
                
                if let credit = dic["creditLimit"] as? Double {
                   self.lbCreditLimit.text = "Limite de Crédito: R$: \(credit)"
                }
                
                if let imageUrl = dic["urlImage"] as? String {
                    if imageUrl != "" {
                        self.imageView.loadImageWithCache(imageUrl)
                    }else{
                        self.imageView.image = UIImage(named: self.dicImage?["withoutPhoto2"] as! String)
                    }
                }
                
            })
            
            refValor = ref.child("shopClientValue")
            refValor.observeSingleEvent(of: .value, with: { (snapShot) in
                var valor = 0.0
                var total = 0.0
                var totalPayment = 0.0
                
                let enumerator = snapShot.children
                while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                    var dic = item.value as! [String: Any]
                    valor = (dic["value"] as? Double)!
                    
                    if let sum = dic["sum"] as? Bool {
                        if sum {
                           total += valor
                        } else {
                           totalPayment += valor
                        }
                    }
                }
                
                self.lbTotalPurchase.text = "Total de Compras: R$: \(total - totalPayment)"
            })
            
        }else {
            Alert(controller: self).showErro(message: "Cliente não selecionado !")
        }
    }
    
    
    func setUpComponentsConfiguration(){
        
        let barButton = UIBarButtonItem(title: "Salvar",
                                    style: UIBarButtonItemStyle.plain,
                                    target: self,
                                    action: #selector(AddValueViewController.save))
        
        barButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = barButton
        btPaymenthistory.layer.cornerRadius = 5
    }

    func save(_ sender: UIButton) {
        var refValores:FIRDatabaseReference!
        var sum = true
        
        if scSoma.selectedSegmentIndex == 1 {
            sum = false
        }
        
        guard var value = tfValor.text else {
            Alert(controller: self).showErro(message: "Preencha o campo valor !")
            return
        }
        
        value = value.replacingOccurrences(of: ",", with: ".")
        
        if let keyCli = key {
            refValores = ref.child("shopClientValue").childByAutoId()
            
            let purchase = Purchase(value: Double(value)!,
                                    date: Date().toString(),
                                    time: Date().hora(),
                                    sum: sum)
        
            let alert = UIAlertController(title: lbNome.text,
                                          message: "Valor Total R$ " + tfValor.text!,
                                          preferredStyle: .alert)
        
            let saveAction = UIAlertAction(title: "Salvar",
                                        style: .default) { action in
                                        
                                        if let userK = self.userKey {
                                            if userK != "" {
                                                if !self.isValidPassword(password: alert.textFields![0].text!){
                                                    Alert(controller: self).showErro(message: "Senha inválida !")
                                                    return
                                                }
                                            }
                                        }
                                            
                                        refValores.setValue(purchase.toAnyObject())
                                        
                
                                        if let navigation = self.navigationController{
                                            navigation.popToRootViewController(animated: true)
                                        }else{
                                            Alert(controller: self).showErro()
                                        }
            }
        
            let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        
            
            if let userK = self.userKey {
                if userK != "" {
                    alert.addTextField(configurationHandler: { (textField) -> Void in
                        textField.placeholder = "senha"
                        textField.isSecureTextEntry = true
                
                    })
                }
            }
            
        
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
        
            present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidPassword(password : String) -> Bool {
        if let userK = userKey {
            if userK == password {
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    @IBAction func btPaymentHistory(_ sender: Any) {
        var payments : String = ""
        
        if let key = key {
            ref = FIRDatabase.database().reference().child("shopClient").child(key)
            refValor = ref.child("shopClientValue")
            refValor.observeSingleEvent(of: .value, with: { (snapShot) in
                
                let enumerator = snapShot.children
                while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                    var dic = item.value as! [String: Any]
                    let data = dic["date"] as? String
                    let valor = (dic["value"] as? Double)!
                    
                    if let sum = dic["sum"] as? Bool {
                        if !sum {
                            if let date = data {
                                payments +=  " \(date) R$: \(valor) \n"
                            }
                        }
                    }
                }
                
                if payments != "" {
                    Alert(controller: self).showSucesso(message: payments)
                }else{
                    Alert(controller: self).showSucesso(message: "Sem registro de pagamento.")
                }
            })
            
        }else {
            Alert(controller: self).showErro(message: "Cliente não selecionado !")
        }
    }
}
