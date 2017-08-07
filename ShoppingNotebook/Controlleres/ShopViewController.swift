//
//  ShopViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 19/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class ShopViewController: UIViewController {

    @IBOutlet weak var tfRazao: HoshiTextField!
    @IBOutlet weak var tfCNPJ: HoshiTextField!
    @IBOutlet weak var tfPhone: HoshiTextField!
    var refShop: FIRDatabaseReference!
    var user : User!
    var edit: Bool = false
    var key: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(title: "Salvar",
                                     style: UIBarButtonItemStyle.plain,
                                     target: self,
                                     action: #selector(ShopViewController.save))
        
        navigationItem.rightBarButtonItem = button
        key = ""
        if (user != nil)
        {
            if edit {
                refShop = FIRDatabase.database().reference().child("shop")
                refShop.queryOrdered(byChild: "userKey").queryEqual(toValue: user.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                   
                    let enumerator = snapshot.children
                    while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                        var dic = item.value as! [String: Any]
                        self.key = item.key
                        self.tfRazao.text = dic["name"] as? String
                        self.tfCNPJ.text = dic["cpjCnpj"] as? String
                        self.tfPhone.text = dic["phone"] as? String
                    }
                    
                    if self.key != "" {
                        self.refShop = FIRDatabase.database().reference().child("shop").child(self.key)
                    }
                })
                
            }else{
                refShop = FIRDatabase.database().reference().child("shop").childByAutoId()
            }
        }else{
            Alert(controller: self).showErro(message: "Usuário não informado !")
        }
    }
    
    func save(){
        if isFieldsFilled(){
            guard let newUser = user else {
                Alert(controller: self).showErro(message: "Usuário não informado !")
                return
            }
            
            guard let name = tfRazao.text else {
                Alert(controller: self).showErro(message: "Preencha o campo Empresa / Razão !")
                return
            }
            
            guard let cpfCnpj = tfCNPJ.text else {
                Alert(controller: self).showErro(message: "Preencha o campo CNPJ !")
                return
            }
            
            guard let phone = tfPhone.text else {
                Alert(controller: self).showErro(message: "Preencha o campo Telefone !")
                return
            }

            let shop = Shop(name: name,
                            cpjCnpj: cpfCnpj,
                            phone: phone,
                            userKey: newUser.uid,
                            key:key)
        
            self.refShop.setValue(shop.toAnyObject())
        
            if edit{
                if let navigation = self.navigationController{
                    navigation.popToRootViewController(animated: true)
                }else{
                    Alert(controller: self).showErro()
                }
            }
            else{
                if let navigation = self.navigationController{
                    navigation.dismiss(animated: true, completion: nil)
                }else{
                    Alert(controller: self).showErro()
                }
            }
        }else{
            Alert(controller: self).showErro(message: "Preencha os campos!")
        }
       
    }
    
    func isFieldsFilled() -> Bool {
        if (tfRazao.text != "") && (tfCNPJ.text != "") && (tfPhone.text != ""){
            return true
        }else{
            return false
        }
    }
}
