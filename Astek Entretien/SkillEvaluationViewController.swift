//
//  PerformanceEvaluationViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 22/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import DLRadioButton
import Firebase

class SkillEvaluationViewController: UIViewController {
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    private var valueButton = ""
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var expertiseButton: DLRadioButton!
    @IBOutlet weak var autonomousButton: DLRadioButton!
    @IBOutlet weak var partialButton: DLRadioButton!
    @IBOutlet weak var notionButton: DLRadioButton!
    
    @IBAction func leftArrowAction(_ sender: Any) {
        createOrUpdate()
        UIUtil.goToPreviousPage(className: className, controller: self)
    }
    
    @IBAction func rightArrowAction(_ sender: Any) {
        if(valueButton == "") {
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
    
        if(!AuthenticationUtil.isManager) {
            expertiseButton.isUserInteractionEnabled = false
            autonomousButton.isUserInteractionEnabled = false
            partialButton.isUserInteractionEnabled = false
            notionButton.isUserInteractionEnabled = false
        }
        
        initSwipeGesture()
        
        className = NSStringFromClass(SkillEvaluationViewController.classForCoder())
        className = className.replacingOccurrences(of: "Astek_Entretien.", with: "")
       pageNumber.text = "Page \(UIUtil.getCurrentPage(className: className)) / \(UIUtil.getTotalPage())"
        
        expertiseButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        autonomousButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        partialButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        notionButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        
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
        if sender === expertiseButton {
            valueButton = "Expertise"
            autonomousButton.isSelected = false
            notionButton.isSelected = false
            partialButton.isSelected = false
        } else if sender === autonomousButton {
            valueButton = "Capacité Autonomone"
            notionButton.isSelected = false
            partialButton.isSelected = false
            expertiseButton.isSelected = false
        } else if sender === partialButton {
            valueButton = "Capacité Partielle"
            autonomousButton.isSelected = false
            notionButton.isSelected = false
            expertiseButton.isSelected = false
            
        } else if sender === notionButton {
            valueButton = "Notion"
            autonomousButton.isSelected = false
            partialButton.isSelected = false
            expertiseButton.isSelected = false
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        if (sender.direction == .left){
            if(valueButton == "") {
                      UIUtil.showMessage(text: StringValues.errorNoInput)
                  } else {
                      createOrUpdate()
                      UIUtil.goToNextPage(className: className, controller: self)
                  }
        }

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
    
    private func createValueInDB(){
        DatabaseUtil.addValueInDataBase(valueToAdd: generateValueForDB(),collectionToCreate: "skillEvaluation")
    }
    
    private func updateValueInDB(){
        DatabaseUtil.updateValueInDataBase(valueToUpdate: generateValueForDB(),collectionToUpdate: "skillEvaluation",documentUpdateId: documentUpdateId)
    }
    
    
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("skillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.get("skillEvaluation") != nil) {
                        self.checkedOneButton(value: (document.get("skillEvaluation") as! String))
                    }
                    self.updateValue = true
                    self.documentUpdateId = document.documentID
                }
            }
        }
    }
    
    private func generateValueForDB() -> [String:String] {
        let skillEvaluation : [String:String] = [
            "skillEvaluation" : valueButton
        ]
        
        return skillEvaluation
    }
    
    
    private func createOrUpdate(){
        if(updateValue){
            updateValueInDB()
        } else {
            createValueInDB()
        }
    }
    
    private func checkedOneButton(value: String){
        valueButton = value
        if(value == "Expertise") {
            expertiseButton.isSelected = true
        }
        if(value == "Capacité Autonome") {
            autonomousButton.isSelected = true
        }
        if(value == "Capacité Partielle") {
            partialButton.isSelected = true
        }
        if(value == "Notion") {
            notionButton.isSelected = true
        }
    }
    
}




// MARK: UITextFieldDelegate
extension SkillEvaluationViewController: UITextFieldDelegate {
    
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
extension SkillEvaluationViewController {
    
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

