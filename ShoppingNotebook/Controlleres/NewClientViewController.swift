//
//  NewClienteViewController.swift
//  ShoppingNotebook
//
//  Created by carina  dos santos pereira on 29/11/16.
//  Copyright © 2016 carina  dos santos pereira. All rights reserved.
//

import UIKit
import Firebase

class NewClienteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tfLimiteCredito: UITextField!
    @IBOutlet weak var tfTelefone: UITextField!
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btFoto: UIButton!
    @IBOutlet weak var tfCPFCNPJ: UITextField!
    @IBOutlet weak var btRegisterUser: UIButton!

    var ref:FIRDatabaseReference!
    var refShop:FIRDatabaseReference!
    var key:String?
    var images:NSArray?
    var dicImage:NSDictionary?
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bundlePath = Bundle.main.path(forResource: "imagens", ofType: "plist"){
            if let dicionario = NSDictionary(contentsOfFile: bundlePath) {
                images = dicionario["images"] as? NSArray
                dicImage = images?[0] as? NSDictionary
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar",
                                                            style: UIBarButtonItemStyle.plain,
                                                            target: self,
                                                            action: #selector(NewClienteViewController.add))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        btFoto.layer.cornerRadius = 5
        btRegisterUser.layer.cornerRadius = 5
        
        if let key = key {
            ref = FIRDatabase.database().reference().child("shopClient").child(key)
            ref.observeSingleEvent(of: .value, with: { (snapShot) in
              
                var dic = snapShot.value as! [String: Any]
                let valor = dic["creditLimit"] as! Double
                self.tfNome.text = dic["name"] as? String
                self.tfTelefone.text = dic["phone"] as? String
                self.tfCPFCNPJ.text = dic ["cpf"] as? String
                self.password = (dic["userKey"] as? String)!
                self.tfLimiteCredito.text = "\(valor)"
                if let imageUrl = dic["urlImage"] as? String {
                    if imageUrl != "" {
                        self.imageView.loadImageWithCache(imageUrl)
                    }else{
                        self.imageView.image = UIImage(named: self.dicImage?["withoutPhoto2"] as! String)
                    }
                }
            })
        }else {
            ref = FIRDatabase.database().reference().child("shopClient").childByAutoId()
        }
        
        refShop = FIRDatabase.database().reference().child("shop")
    }
    
    func isFieldsFilled() -> Bool {
        if (tfNome.text != "") && (tfCPFCNPJ.text != "") && (tfTelefone.text != "") && (tfLimiteCredito.text != ""){
            return true
        }
        
        return false
    }
    
    func add(){
        if isFieldsFilled(){
            guard let name = tfNome.text else {
                Alert(controller: self).showErro(message: "Preencha o campo nome !")
                return
            }
        
            guard let cpf = tfCPFCNPJ.text else {
                Alert(controller: self).showErro(message: "Preencha o campo CPF / CNPJ !")
                return
            }
        
            guard let phone = tfTelefone.text else {
                Alert(controller: self).showErro(message: "Preencha o campo telefone !")
                return
            }
        
            guard var creditLimit = tfLimiteCredito.text else {
                Alert(controller: self).showErro(message: "Preencha o campo limite de crédito !")
                return
            }
        
            creditLimit = creditLimit.replacingOccurrences(of: ",", with: ".")
        
            if let user = FIRAuth.auth()?.currentUser {
                
                var shopKey : String = ""
            
                refShop.queryOrdered(byChild: "userKey").queryEqual(toValue: user.uid).observe(.value) { (snapshot:FIRDataSnapshot) in
                
                let enumerator = snapshot.children
                while let item:FIRDataSnapshot = enumerator.nextObject() as? FIRDataSnapshot {
                    shopKey = item.key as String
                }
            
          
                if shopKey != "" {
                
                    let shopClient = ShopClient(name: name,
                                                cpf: cpf,
                                                phone: phone,
                                                creditLimit: Double(creditLimit)!,
                                                shopKey: shopKey,
                                                userKey: self.password)
                
                
                
                    //Verifica se o usário inseriu uma imagem e converse para o tipo Data
                    if let data = self.imageView.image, let imageData = UIImageJPEGRepresentation(data, 0.5) {
                    
                        let storage = FIRStorage.storage()
                        let storageRef = storage.reference(forURL: "gs://shoppingnotebook-1ef66.appspot.com")
                        let imageName = UUID().uuidString //Cria uma nova string única toda vez que é chamada
                        let spaceRef = storageRef.child("images/\(imageName).jpg")
                        spaceRef.put(imageData, metadata: nil) { (metadata, error) in
                            if error != nil {
                                Alert(controller: self).showErro(message: "Imagem não foi salva!")
                                return
                            }
                        
                            if let imageUrl = metadata?.downloadURL()?.absoluteString {
                                shopClient.urlImage = imageUrl
                                self.ref.setValue(shopClient.toAnyObject())
                            }
                        }
                    }
                    else {
                        self.ref.setValue(shopClient.toAnyObject())
                    }
                
                
                    if let navigation = self.navigationController{
                        navigation.popToRootViewController(animated: true)
                    }else{
                        Alert(controller: self).showErro()
                    }
                }
            }
           
            }else{
                Alert(controller: self).showErro(message: "Usuário não encontrado !")
            }
        }else{
            Alert(controller: self).showErro(message: "Preencha os campos !")
        }
    }
    
    @IBAction func btFoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = editImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btRegisterUser(_ sender: Any) {
        let alert = UIAlertController(title: "Digite uma senha",
                                      message: "Está senha deve ser definida pelo cliente.",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField1) -> Void in
            textField1.placeholder = "senha"
            textField1.isSecureTextEntry = true
            
        })
        
        
        alert.addTextField(configurationHandler: { (textField2) -> Void in
            textField2.placeholder = "confirmação senha"
            textField2.isSecureTextEntry = true
            
        })
        
        
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        
        let saveAction = UIAlertAction(title: "Salvar",
                                       style: .default) { action in
                                        
                                        if (alert.textFields?[0].text != "") && (alert.textFields?[1].text != "") {
                                            if alert.textFields?[0].text == alert.textFields?[1].text {
                                                self.password = (alert.textFields?[0].text)!
                                            }else{
                                                self.password = ""
                                                Alert(controller: self).showErro(message: "As senhas devem serem iguais!")
                                                return
                                            }
                                        }else{
                                            Alert(controller: self).showErro(message: "Digite uma senha!")
                                            return
                                        }
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
    }// end func
}
