//
//  ProfilCreationViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 19/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import DLRadioButton

class ProfilCreationViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var societyText: UITextField!
    @IBOutlet weak var birthDateText: UITextField!
    @IBOutlet weak var enterDateText: UITextField!
    @IBOutlet weak var experimentDateText: UITextField!
    @IBOutlet weak var functionText: UITextField!
    @IBOutlet weak var diplomText: UITextField!
    @IBOutlet weak var obtentionDateText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var managerButton: DLRadioButton!
    @IBOutlet weak var salarieButton: DLRadioButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func createProfilAction(_ sender: Any) {
        if(checkFieldEmpty()) {
            UIUtil.showMessage(text: StringValues.errorNoInput)
        } else {
            addInfoInProfil()
            AuthenticationUtil.createUser(email: mailText.text!, password: passwordText.text!, controller: self)
        }
    }
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var profilFunction = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate()
        setBorder()
        
        managerButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        salarieButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        
        // setup keyboard event
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func buttonClicked(_ sender: UIButton) {
        if sender === managerButton {
            profilFunction = "manager"
        } else if sender === salarieButton {
            profilFunction = "salarie"
        }
    }
    
    
    func delegate() {
        nameText.delegate = self
        surnameText.delegate = self
        societyText.delegate = self
        nameText.delegate = self
        birthDateText.delegate = self
        enterDateText.delegate = self
        experimentDateText.delegate = self
        functionText.delegate = self
        obtentionDateText.delegate = self
        diplomText.delegate = self
        mailText.delegate = self
        passwordText.delegate = self
    }
    
    func setBorder(){
        UIUtil.setBottomBorder(textField: nameText)
        UIUtil.setBottomBorder(textField: surnameText)
        UIUtil.setBottomBorder(textField: societyText)
        UIUtil.setBottomBorder(textField: functionText)
        UIUtil.setBottomBorder(textField: birthDateText)
        UIUtil.setBottomBorder(textField: enterDateText)
        UIUtil.setBottomBorder(textField: experimentDateText)
        UIUtil.setBottomBorder(textField: diplomText)
        UIUtil.setBottomBorder(textField: obtentionDateText)
        UIUtil.setBottomBorder(textField: mailText)
        UIUtil.setBottomBorder(textField: passwordText)
    }
    
    
    func checkFieldEmpty() -> Bool {
        if(nameText.text == "" || surnameText.text == ""
            || societyText.text == "" || birthDateText.text == ""
            || enterDateText.text == "" || experimentDateText.text == ""
            || functionText.text == "" || diplomText.text == ""
            || obtentionDateText.text == "" || mailText.text == ""
            || passwordText.text == "" || profilFunction == "") {
            return true
        } else {
            return false
        }
    }
    
    func addInfoInProfil(){
        
        // Create a new user with profil informations
        let profilUser : [String: String] = [
            "name" : nameText.text!,
            "surname" : surnameText.text!,
            "profilFunction" : profilFunction,
            "society" : societyText.text!,
            "birthdate" : birthDateText.text!,
            "enterDate" : enterDateText.text!,
            "experimentDate" : experimentDateText.text!,
            "function" : functionText.text!,
            "diplom" : diplomText.text!,
            "obtentionDate" : obtentionDateText.text!,
            "mail" : mailText.text!,
            "page" : "1"
        ]
        
        DatabaseUtil.createProfil(valueToAdd: profilUser)
    }
}







// MARK: UITextFieldDelegate
extension ProfilCreationViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        //activeField = nil
        return true
    }
}

// MARK: Keyboard Handling
extension ProfilCreationViewController {
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        if keyboardHeight != nil {
            return
        }
        
        let userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardFrame.height
        
        // so increase contentView's height by keyboard height
        UIView.animate(withDuration: 0.3, animations: {
            self.constraintContentHeight.constant += self.keyboardHeight
        })
        
        // move if keyboard hide input field
        let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
        let collapseSpace = keyboardHeight - distanceToBottom
        
        if collapseSpace < 0 {
            // no collapse
            return
        }
        
        // set new offset for scroll view
        UIView.animate(withDuration: 0.3, animations: {
            // scroll to the position above keyboard 10 points
            self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
        })
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        UIView.animate(withDuration: 0.3) {
            if(self.constraintContentHeight != nil) {
                self.constraintContentHeight.constant -= self.keyboardHeight
            }
            
            self.scrollView.contentOffset = self.lastOffset
        }
        
        keyboardHeight = nil
    }
}
