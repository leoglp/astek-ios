//
//  EmployeeAppreciationViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 21/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase

class EmployeeAppreciationViewController: UIViewController {
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    
    @IBOutlet weak var gainText: UITextField!
    @IBOutlet weak var improveText: UITextField!
    @IBOutlet weak var weaknessText: UITextField!
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    
    @IBAction func leftArrowAction(_ sender: Any) {
        createOrUpdate()
        UIUtil.goToPreviousPage(className: className, controller: self)
    }
    
    
    @IBAction func rightArrowAction(_ sender: Any) {
        if(gainText.text == "" || weaknessText.text == ""
            || improveText.text == "") {
            UIUtil.showMessage(text: StringValues.errorNoInput)
        } else {
            createOrUpdate()
            UIUtil.goToNextPage(className: className, controller: self)
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        UIUtil.backToHome(controller: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initText()
        initSwipeGesture()
        
        className = NSStringFromClass(EmployeeAppreciationViewController.classForCoder())
        className = className.replacingOccurrences(of: "Astek_Entretien.", with: "")
        print("TITI className : \(className)")
        
        
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
        if (sender.direction == .left)
        {
           if(gainText.text == "" || weaknessText.text == ""
               || improveText.text == "") {
               UIUtil.showMessage(text: StringValues.errorNoInput)
           } else {
               createOrUpdate()
               UIUtil.goToNextPage(className: className, controller: self)
           }
        }

        if (sender.direction == .right)
        {
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
    
    private func createValueInDB(){
        DatabaseUtil.addValueInDataBase(valueToAdd: generateValueForDB(),collectionToCreate: "employeeAppreciation")
    }
    
    private func updateValueInDB(){
        DatabaseUtil.updateValueInDataBase(valueToUpdate: generateValueForDB(),collectionToUpdate: "employeeAppreciation",documentUpdateId: documentUpdateId)
    }
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("employeeAppreciation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.get("gain") != nil) {
                        self.gainText.text = (document.get("gain") as! String)
                    }
                    if (document.get("weaknesses") != nil) {
                        self.weaknessText.text = (document.get("weaknesses") as! String)
                    }
                    if (document.get("improvement") != nil) {
                        self.improveText.text = (document.get("improvement") as! String)
                    }
                    self.updateValue = true
                    self.documentUpdateId = document.documentID
                }
            }
        }
    }
    
    private func generateValueForDB() -> [String:String] {
        let employeeAppreciation : [String:String] = [
            "gain" : gainText.text!,
            "weaknesses" : weaknessText.text!,
            "improvement" : improveText.text!
        ]
        return employeeAppreciation
    }
    
    
    private func createOrUpdate(){
        if(updateValue){
            updateValueInDB()
        } else {
            createValueInDB()
        }
    }
    
    private func initText() {
        gainText.delegate = self
        gainText.textAlignment = .left
        gainText.contentVerticalAlignment = .top
        improveText.delegate = self
        improveText.textAlignment = .left
        improveText.contentVerticalAlignment = .top
        weaknessText.delegate = self
        weaknessText.textAlignment = .left
        weaknessText.contentVerticalAlignment = .top
    }
    
    
}





// MARK: UITextFieldDelegate
extension EmployeeAppreciationViewController: UITextFieldDelegate {
    
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
extension EmployeeAppreciationViewController {
    
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
            if(self.constraintContentHeight != nil) {
                self.constraintContentHeight.constant -= self.keyboardHeight
            }
            
            self.scrollView.contentOffset = self.lastOffset
        }
        
        keyboardHeight = nil
    }
}

