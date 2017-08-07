//
//  SingUpViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 27/11/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import FirebaseAuth
import TextFieldEffects

class SingUpViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var tfConfirmPassword: HoshiTextField!
    @IBOutlet weak var tfPassword: HoshiTextField!
    @IBOutlet weak var tfEmail: HoshiTextField!
    
    var typeOfUser: String = ""
    var edit: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()

        if edit {
            if let user = FIRAuth.auth()?.currentUser{
                navigationItem.title = "Perfil"
                self.tfEmail.text = user.email
                self.tfEmail.isEnabled = false
                self.tfPassword.isHidden = true
                self.tfConfirmPassword.isHidden = true
            }
        }else{
            let saveButton = UIBarButtonItem(title: "Salvar",
                                             style: UIBarButtonItemStyle.plain,
                                             target: self,
                                             action: #selector(SingUpViewController.save))
            
            navigationItem.rightBarButtonItem = saveButton
            navigationItem.title = typeOfUser
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
        tfConfirmPassword.resignFirstResponder()
    }
    
    func save(){
        if isIgualPassword(){
            if isFieldsFilled(){
                FIRAuth.auth()?.createUser(withEmail: tfEmail.text!, password: tfPassword.text!, completion: {(user, error) in
                if error != nil {
                    Alert(controller: self).showErro(message: "Erro, não foi possível criar o usuário !")
                }else{
                    
                    
                    if let user = FIRAuth.auth()?.currentUser{
                    
                        if (self.typeOfUser == "Cliente"){
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clientViewControllerId") as! ClientViewController
                            
                            if let navigation = self.navigationController{
                                vc.user = User(authData: user)
                                navigation.pushViewController(vc, animated: true)
                            }else{
                                Alert(controller: self).showErro()
                            }
                        }else {
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shopViewControllerId") as! ShopViewController
                            
                            if let navigation = self.navigationController{
                                vc.user = User(authData: user)
                                navigation.pushViewController(vc, animated: true)
                            }else{
                                Alert(controller: self).showErro()
                            }
                        }
                        
                    }
                }
            })
            } else {
                Alert(controller: self).showErro(message: "Preencha as informações!")
            }
        } else {
            Alert(controller: self).showErro(message: "As senhas devem serem iguais!")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == tfEmail){
            tfPassword.becomeFirstResponder()
            return true
        }
        
        return false
    }
    
    func  isIgualPassword() -> Bool {
        if (tfPassword.text == tfConfirmPassword.text){
            return true
        }else{
            return false
        }
    }
    
    func isFieldsFilled() -> Bool {
        if (tfPassword.text != "") && (tfEmail.text != ""){
            return true
        } else {
            return false
        }
    }
}
