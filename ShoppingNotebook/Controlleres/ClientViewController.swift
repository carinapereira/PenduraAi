//
//  ClientViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 19/12/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class ClientViewController: UIViewController {

    @IBOutlet weak var tfName: HoshiTextField!
    @IBOutlet weak var tfCPF: HoshiTextField!
    @IBOutlet weak var tfPhone: HoshiTextField!
    @IBOutlet weak var tfPassword: HoshiTextField!
    var refClient : FIRDatabaseReference!
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIBarButtonItem(title: "Salvar",
                                     style: UIBarButtonItemStyle.plain,
                                     target: self,
                                     action: #selector(ClientViewController.save))
        
        navigationItem.rightBarButtonItem = button
        
        if user != nil{
            refClient = FIRDatabase.database().reference().child("client").childByAutoId()
        }else{
            Alert(controller: self).showErro(message: "Usuário não informado !")
        }
        
    }
    
    func save(){
        guard let newUser = user else {
            Alert(controller: self).showErro(message: "Usuário não informado !")
            return
        }
        
        guard let name = tfName.text else {
            Alert(controller: self).showErro(message: "Preencha o campo nome !")
            return
        }
        
        guard let cpf = tfCPF.text else {
            Alert(controller: self).showErro(message: "Preencha o campo CPF !")
            return
        }
        
        guard let phone = tfPhone.text else {
            Alert(controller: self).showErro(message: "Preencha o campo Telefone !")
            return
        }
        
        guard let limit = tfPassword.text else {
            Alert(controller: self).showErro(message: "Preecha o campo senha !")
            return
        }
      
        let client = ShopClient(name: name, cpf: cpf, phone: phone, creditLimit: 0.0, shopKey: "ddd")
     
        
        self.refClient.setValue(client.toAnyObject())
        
        if let navigation = navigationController {
            navigation.dismiss(animated: true, completion: nil)
        } else {
            Alert(controller: self).showErro()
        }
    }

}
