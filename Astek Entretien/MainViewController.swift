//
//  ViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 14/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailText.delegate = self
        passwordText.delegate = self
    }
    
    
    
    @IBAction func connexionAction(_ sender: Any) {
        if((mailText.text == "") || passwordText.text == "") {
            UIUtil.showMessage(text: StringValues.errorNoInput)
        } else {
            mailText.resignFirstResponder()
            passwordText.resignFirstResponder()
            AuthenticationUtil.signIn(controller: self,email: mailText.text!, password: passwordText.text!)
        }
    }
    
    @IBAction func profilCreationAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showProfilCreation", sender: nil)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showReset", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

