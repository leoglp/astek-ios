//
//  InterviewContextViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 14/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase

class InterviewViewController: UIViewController {
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    
    
    @IBOutlet weak var bilanDateText: UITextField!
    @IBOutlet weak var previousDateText: UITextField!
    @IBOutlet weak var currentDateText: UITextField!
    @IBOutlet weak var managerNameText: UITextField!
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    
    @IBAction func leftArrowAction(_ sender: Any) {
        createOrUpdate()
        if(AuthenticationUtil.isManager) {
            UIUtil.goToPage(pageNumber: -1, controller: self)
        } else {
            UIUtil.backToHome(controller: self)
        }
    }
    
    
    @IBAction func rightArrowAction(_ sender: Any) {
        if(bilanDateText.text == "" || previousDateText.text == ""
            || currentDateText.text == "" || managerNameText.text == "") {
                   UIUtil.showMessage(text: StringValues.errorNoInput)
               } else {
            createOrUpdate()
            UIUtil.goToNextPage(className: className, controller: self)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bilanDateText.delegate = self
        previousDateText.delegate = self
        currentDateText.delegate = self
        managerNameText.delegate = self
        
        UIUtil.setBottomBorder(textField: bilanDateText)
        UIUtil.setBottomBorder(textField: previousDateText)
        UIUtil.setBottomBorder(textField: currentDateText)
        UIUtil.setBottomBorder(textField: managerNameText)
        
        className = NSStringFromClass(InterviewViewController.classForCoder())
        className = className.replacingOccurrences(of: "Astek_Entretien.", with: "")
        
        
        pageNumber.text = "Page \(UIUtil.getCurrentPage(className: className)) / \(UIUtil.getTotalPage())"
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveData()
    }
    
    
    
    
    private func createValueInDB(){
        let interviewContext : [String:String] = [
            "bilanDate" : bilanDateText.text!,
            "previousDate" : previousDateText.text!,
            "interviewDate" : currentDateText.text!,
            "managerName" : managerNameText.text!
        ]
        
        DatabaseUtil.addValueInDataBase(valueToAdd: interviewContext,collectionToCreate: "interviewContext")
    }
    
    private func updateValueInDB(){
        
        let interviewContext : [String:String] = [
            "bilanDate" : bilanDateText.text!,
            "previousDate" : previousDateText.text!,
            "interviewDate" : currentDateText.text!,
            "managerName" : managerNameText.text!
        ]
        
        DatabaseUtil.updateValueInDataBase(valueToUpdate: interviewContext,collectionToUpdate: "interviewContext",documentUpdateId: documentUpdateId)
    }
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("interviewContext").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                
                for document in querySnapshot!.documents {
                    if (document.get("bilanDate") != nil) {
                        self.bilanDateText.text = (document.get("bilanDate") as! String)
                    }
                    if (document.get("previousDate") != nil) {
                        self.previousDateText.text = (document.get("previousDate") as! String)
                    }
                    if (document.get("interviewDate") != nil) {
                        self.currentDateText.text = (document.get("interviewDate") as! String)
                    }
                    if (document.get("managerName") != nil) {
                        self.managerNameText.text = (document.get("managerName") as! String)
                    }
                    self.updateValue = true
                    self.documentUpdateId = document.documentID
                    
                }
            }
        }
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
extension InterviewViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}


// MARK: Keyboard Handling
extension InterviewViewController {
    
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

