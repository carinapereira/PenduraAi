//
//  LoginViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 27/11/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btCriarConta: UIButton!
    @IBOutlet weak var btEntrar: UIButton!
    var refShop:FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        btCriarConta.layer.cornerRadius = 5
        btEntrar.layer.cornerRadius = 5
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfEmail.resignFirstResponder()
        tfSenha.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == tfEmail){
            tfSenha.becomeFirstResponder()
            return true
        }else if (textField == tfSenha){
            btEntrar.becomeFirstResponder()
            return true
        }
        
        return false
    }

    @IBAction func btEntrar(_ sender: UIButton) {
        var isRegistered:Bool = false
        
        FIRAuth.auth()?.signIn(withEmail: tfEmail.text!, password: tfSenha.text!, completion: {(user, error) in
            if error != nil{
                Alert(controller: self).showSucesso(message: "Usuário não encontrado!")
            }else{
                if let user = FIRAuth.auth()?.currentUser {
                    self.refShop = FIRDatabase.database().reference().child("shop")
                    self.refShop.queryOrdered(byChild: "userKey").queryEqual(toValue: user.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                    
                        let enumerator = snapshot.children
                        while let _:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                            isRegistered = true
                        }
                    
                        if isRegistered{
                            if let navigation = self.navigationController {
                                navigation.dismiss(animated: true, completion: nil)
                            } else {
                                Alert(controller: self).showErro()
                            }
                        }else{
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shopViewControllerId") as! ShopViewController
                            if let navigation = self.navigationController{
                                vc.user = User(authData: user)
                                vc.edit = false
                                navigation.pushViewController(vc, animated: true)
                            
                            }else{
                                Alert(controller: self).showErro()
                            }
                        }
                    })
                }
            }
        })
    }
}
