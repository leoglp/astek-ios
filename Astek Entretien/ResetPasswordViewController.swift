//
//  ResetPasswordViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 15/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var mailText: UITextField!
    
    @IBAction func resetButton(_ sender: Any) {
        if(mailText.text == "") {
            UIUtil.showMessage(text: StringValues.errorNoInput)
        } else {
            AuthenticationUtil.resetPassword(email: mailText.text!, controller: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailText.delegate = self
    }
    
}

// MARK: UITextFieldDelegate
extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
