//
//  CPFViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 28/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase

class CPFViewController: UIViewController {
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    private var buttonValue = ""
    
    @IBOutlet weak var numberHoursText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var commentaryText: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBAction func leftArrowAction(_ sender: Any) {
        createOrUpdate()
        UIUtil.goToPreviousPage(className: className, controller: self)
    }
    
    
    @IBAction func rightArrowAction(_ sender: Any) {
        if(numberHoursText.text == "" || dateText.text == "" || buttonValue == ""
            || commentaryText.text == "") {
            UIUtil.showMessage(text: StringValues.errorNoInput)
        } else {
            createOrUpdate()
            UIUtil.goToNextPage(className: className, controller: self)
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        UIUtil.backToHome(controller: self)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initText()
        initSwipeGesture()
        
        className = NSStringFromClass(CPFViewController.classForCoder())
        className = className.replacingOccurrences(of: "Astek_Entretien.", with: "")
        pageNumber.text = "Page \(UIUtil.getCurrentPage(className: className)) / \(UIUtil.getTotalPage())"
        
        
        yesButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        
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
    
    @objc func buttonClicked(_ sender: UIButton) {
        if sender === yesButton {
            buttonValue = "OUI"
            noButton.isSelected = false
        } else if sender === noButton {
            buttonValue = "NON"
            yesButton.isSelected = false
        }
    }
    
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        if (sender.direction == .left){
            if(numberHoursText.text == "" || dateText.text == "" || buttonValue == ""
                || commentaryText.text == "") {
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
        DatabaseUtil.addValueInDataBase(valueToAdd: generateValueForDB(),collectionToCreate: "cpf")
    }
    
    private func updateValueInDB(){
        DatabaseUtil.updateValueInDataBase(valueToUpdate: generateValueForDB(),collectionToUpdate: "cpf",documentUpdateId: documentUpdateId)
    }
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("cpf").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.get("numberHours") != nil) {
                        self.numberHoursText.text = (document.get("numberHours") as! String)
                    }
                    if (document.get("date") != nil) {
                        self.dateText.text = (document.get("date") as! String)
                    }
                    if (document.get("question") != nil) {
                        self.checkedButton(value: (document.get("question") as! String))
                    }
                    if (document.get("commentary") != nil) {
                        self.commentaryText.text = (document.get("commentary") as! String)
                    }
                    self.updateValue = true
                    self.documentUpdateId = document.documentID
                }
            }
        }
    }
    
    private func generateValueForDB() -> [String:String] {
        let cpf : [String:String] = [
            "numberHours" : numberHoursText.text!,
            "date" : dateText.text!,
            "question" : buttonValue,
            "commentary" : commentaryText.text!
        ]
        return cpf
    }
    
    
    private func createOrUpdate(){
        if(updateValue){
            updateValueInDB()
        } else {
            createValueInDB()
        }
    }
    
    private func initText() {
        numberHoursText.delegate = self
        UIUtil.setBottomBorder(textField: numberHoursText)
        dateText.delegate = self
        UIUtil.setBottomBorder(textField: dateText)
        dateText.textAlignment = .left
        dateText.contentVerticalAlignment = .top
        commentaryText.delegate = self
        commentaryText.textAlignment = .left
        commentaryText.contentVerticalAlignment = .top
        
        if(!AuthenticationUtil.isManager) {
            UIUtil.textDisabled(textField: commentaryText)
        }
    }
    
    private func checkedButton(value: String){
        buttonValue = value
        if(value == "OUI") {
            yesButton.isSelected = true
        }
        if(value == "NON") {
            noButton.isSelected = true
        }
    }
    
}






// MARK: UITextFieldDelegate
extension CPFViewController: UITextFieldDelegate {
    
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
extension CPFViewController {
    
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
