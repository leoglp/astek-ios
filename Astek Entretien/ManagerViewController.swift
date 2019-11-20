//
//  ManagerViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 15/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit

class ManagerViewController: UIViewController {
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    
    @IBAction func validateButton(_ sender: Any) {
        if(nameText.text == "" || surnameText.text == "") {
            UIUtil.showMessage(text: StringValues.errorNoInput)
        } else {
            nameText.resignFirstResponder()
            surnameText.resignFirstResponder()
            DatabaseUtil.retrieveMailAddress(name: (nameText!.text?.lowercased())!, surname: (surnameText!.text?.lowercased())!,controller: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameText.delegate = self
        surnameText.delegate = self
    }
    
}

// MARK: UITextFieldDelegate
extension ManagerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

