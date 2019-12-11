//
//  SettingsViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 09/12/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBAction func profilAction(_ sender: Any) {
        performSegue(withIdentifier: "showProfilModification", sender: nil)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if(AuthenticationUtil.isManager){
            UIUtil.showMessage(text: StringValues.processing)
            performSegue(withIdentifier: "firstPDF", sender: nil)
        } else {
            MailUtil.sendEmail(controller: self, mailComposeDelegate: self , recipient: "")
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        DatabaseUtil.readAndGoToPage(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(AuthenticationUtil.isManager) {
            
            sendButton.setTitle(StringValues.generateReport, for: .normal)
        } else {
            sendButton.setTitle(StringValues.notifyManager, for: .normal)
        }
        // setup keyboard event
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}






// MARK: UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.activeField?.resignFirstResponder()
        //self.activeField = nil
        return true
    }
}


// MARK: Keyboard Handling
extension SettingsViewController {
    
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
        var distanceToBottom : CGFloat?
        if(scrollView != nil) {
             distanceToBottom = scrollView.frame.size.height - (self.activeField?.frame.origin.y)! - (self.activeField?.frame.size.height)!
        }
        
        let collapseSpace = keyboardHeight - distanceToBottom!
        
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
            if(self.constraintContentHeight != nil && self.keyboardHeight != nil) {
                self.constraintContentHeight.constant -= self.keyboardHeight
            }
            
            self.scrollView.contentOffset = self.lastOffset
        }
        
        keyboardHeight = nil
    }
}




// MARK: MFMailComposeViewControllerDelegate
extension SettingsViewController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc private func presentExampleController() {
        let exampleStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let exampleVC = exampleStoryboard.instantiateViewController(withIdentifier: "SynthesisView") as! SynthesisViewController
        present(exampleVC, animated: true)
    }
    
}
