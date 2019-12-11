//
//  SynthesisViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 29/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class SynthesisViewController: UIViewController {
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    
    @IBOutlet weak var synthesisText: UITextField!
    @IBOutlet weak var resultButton: UIButton!
    
    
    //Mail Stack View
    @IBOutlet weak var mailStackView: UIStackView!
    @IBOutlet weak var mailTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mailStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mailText: UITextField!
    
    
    @IBOutlet weak var rightArrow: UIButton!
    
    @IBAction func ClickOnResultButton(_ sender: Any) {
        if(AuthenticationUtil.isManager){
            createOrUpdate()
            UIUtil.showMessage(text: StringValues.processing)
            performSegue(withIdentifier: "firstPDF", sender: nil)
        } else {
            if(mailText.text == ""){
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                MailUtil.sendEmail(controller: self, mailComposeDelegate: self , recipient: mailText.text!)
            }
        }
    }
    
    
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBAction func leftArrowAction(_ sender: Any) {
        createOrUpdate()
        UIUtil.goToPreviousPage(className: className, controller: self)
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        UIUtil.backToHome(controller: self)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightArrow.isHidden = true
        rightArrow.isUserInteractionEnabled = false
        
        initText()
        initSwipeGesture()
        
        className = NSStringFromClass(SynthesisViewController.classForCoder())
        className = className.replacingOccurrences(of: "Astek_Entretien.", with: "")
        pageNumber.text = "Page \(UIUtil.getCurrentPage(className: className)) / \(UIUtil.getTotalPage())"
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        if (sender.direction == .right){
            createOrUpdate()
            UIUtil.goToPreviousPage(className: className, controller: self)
        }
    }
    
    private func initSwipeGesture(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    private func initText(){
        
        synthesisText.delegate = self
        synthesisText.textAlignment = .left
        synthesisText.contentVerticalAlignment = .top
        
        mailText.delegate = self
        
        if(AuthenticationUtil.isManager) {
            mailStackView.isHidden = true
            mailTopConstraint.constant = 0
            mailStackViewHeight.constant = 0
            resultButton.setTitle(StringValues.generateReport, for: .normal)
        } else {
            UIUtil.textDisabled(textField: synthesisText)
            
            mailStackView.isHidden = false
            mailTopConstraint.constant = 30
            mailStackViewHeight.constant = 40
            
            resultButton.setTitle(StringValues.notifyManager, for: .normal)
        }
    }
    
    private func createValueInDB(){
        DatabaseUtil.addValueInDataBase(valueToAdd: generateValueForDB(),collectionToCreate: "synthesis")
    }
    
    private func updateValueInDB(){
        DatabaseUtil.updateValueInDataBase(valueToUpdate: generateValueForDB(),collectionToUpdate: "synthesis",documentUpdateId: documentUpdateId)
    }
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("synthesis").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.get("synthesis") != nil) {
                        self.synthesisText.text = (document.get("synthesis") as! String)
                    }
                    self.updateValue = true
                    self.documentUpdateId = document.documentID
                    
                }
            }
        }
    }
    
    private func generateValueForDB() -> [String:String] {
        let synthesis : [String:String] = [
            "synthesis" : synthesisText.text!
            
        ]
        
        return synthesis
    }
    
    
    private func createOrUpdate(){
        if(updateValue){
            updateValueInDB()
        } else {
            createValueInDB()
        }
    }
    
    
    
    
    
}



// MARK: UITextFieldDelegate
extension SynthesisViewController: UITextFieldDelegate {
    
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
extension SynthesisViewController {
    
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
        let distanceToBottom = scrollView.frame.size.height - (self.activeField?.frame.origin.y)! - (self.activeField?.frame.size.height)!
        
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
            if(self.constraintContentHeight != nil && self.keyboardHeight != nil) {
                self.constraintContentHeight.constant -= self.keyboardHeight
            }
            
            self.scrollView.contentOffset = self.lastOffset
        }
        
        keyboardHeight = nil
    }
}




// MARK: MFMailComposeViewControllerDelegate
extension SynthesisViewController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc private func presentExampleController() {
        let exampleStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let exampleVC = exampleStoryboard.instantiateViewController(withIdentifier: "SynthesisView") as! SynthesisViewController
        present(exampleVC, animated: true)
    }
    
}



