//
//  TargetEvaluationViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 21/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase

class TargetEvaluationViewController: UIViewController {
    
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    private var numberTarget = 1
    
    
    //Target1 Stack View
    @IBOutlet weak var targetStackView1: UIStackView!
    @IBOutlet weak var targetTopConstraint1: NSLayoutConstraint!
    @IBOutlet weak var targetStackViewHeight1: NSLayoutConstraint!
    @IBOutlet weak var target1: UITextField!
    
    //Result1 Stack View
    @IBOutlet weak var resultStackView1: UIStackView!
    @IBOutlet weak var resultTopConstraint1: NSLayoutConstraint!
    @IBOutlet weak var resultStackViewHeight1: NSLayoutConstraint!
    @IBOutlet weak var result1: UITextField!
    
    //Target2 Stack View
    @IBOutlet weak var targetStackView2: UIStackView!
    @IBOutlet weak var targetTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var targetStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var target2: UITextField!
    
    //Result2 Stack View
    @IBOutlet weak var resultStackView2: UIStackView!
    @IBOutlet weak var resultTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var resultStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var result2: UITextField!
    
    //Target3 Stack View
    @IBOutlet weak var targetStackView3: UIStackView!
    @IBOutlet weak var targetTopConstraint3: NSLayoutConstraint!
    @IBOutlet weak var targetStackViewHeight3: NSLayoutConstraint!
    @IBOutlet weak var target3: UITextField!
    
    //Result3 Stack View
    @IBOutlet weak var resultStackView3: UIStackView!
    @IBOutlet weak var resultTopConstraint3: NSLayoutConstraint!
    @IBOutlet weak var resultStackViewHeight3: NSLayoutConstraint!
    @IBOutlet weak var result3: UITextField!
    
    //Button Stack View
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
   
    
    
    @IBAction func leftArrowAction(_ sender: Any) {
        createOrUpdate()
        UIUtil.goToPreviousPage(className: className, controller: self)
    }
    
    @IBAction func rightArrowAction(_ sender: Any) {
        switch numberTarget {
        case 1:
            if(target1.text == "" || result1.text == "") {
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                createOrUpdate()
                UIUtil.goToNextPage(className: className, controller: self)
            }
        case 2:
            if(target1.text == "" || result1.text == ""
                || target2.text == "" || result2.text == "") {
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                createOrUpdate()
                UIUtil.goToNextPage(className: className, controller: self)
            }
        case 3:
            if(target1.text == "" || result1.text == ""
                || target2.text == "" || result2.text == ""
                || target3.text == "" || result3.text == "") {
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                createOrUpdate()
                UIUtil.goToNextPage(className: className, controller: self)
            }
        default:
            return
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        UIUtil.backToHome(controller: self)
    }
    
    @IBAction func addAction(_ sender: Any) {
        updateTargetViewButton(isAdded: true)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        updateTargetViewButton(isAdded: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initText()
        
        className = NSStringFromClass(TargetEvaluationViewController.classForCoder())
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
    
    private func initText() {
        target1.delegate = self
        UIUtil.textAlign(textField: target1)
        result1.delegate = self
        UIUtil.textAlign(textField: result1)
        target2.delegate = self
        UIUtil.textAlign(textField: target2)
        result2.delegate = self
        UIUtil.textAlign(textField: result2)
        target3.delegate = self
        UIUtil.textAlign(textField: target3)
        result3.delegate = self
        UIUtil.textAlign(textField: result3)
        
        
        if(!AuthenticationUtil.isManager) {
            UIUtil.textDisabled(textField: target1)
            UIUtil.textDisabled(textField: result1)
            UIUtil.textDisabled(textField: target2)
            UIUtil.textDisabled(textField: result2)
            UIUtil.textDisabled(textField: target3)
            UIUtil.textDisabled(textField: result3)
        }
    }
    
    
    private func updateTargetView(){
        UIUtil.updateViewForThreeValues(number: numberTarget, constraintContentHeight: constraintContentHeight, stackView1: targetStackView2, topConstraint1: targetTopConstraint2, heightConstraint1: targetStackViewHeight2, stackView2: resultStackView2, topConstraint2: resultTopConstraint2, heightConstraint2: resultStackViewHeight2, stackView3: targetStackView3, topConstraint3: targetTopConstraint3, heightConstraint3: targetStackViewHeight3, stackView4: resultStackView3, topConstraint4: resultTopConstraint3, heightConstraint4: resultStackViewHeight3)
        UIUtil.updateButtonForThreeValues(number: numberTarget, constraintContentHeight: constraintContentHeight, isManager: AuthenticationUtil.isManager, stackView: buttonStackView, bottomConstraint1: buttonBottomConstraint, heightConstraint1: buttonBottomConstraint, buttonAdd: addButton, buttonDelete: deleteButton)
        self.view.layoutIfNeeded()
    }
    
    private func updateTargetViewButton(isAdded: Bool) {
        if(isAdded) {
            numberTarget += 1
        } else {
            numberTarget -= 1
        }
        updateTargetView()
    }
    
    
    
    private func createValueInDB(){
        var targetEvaluation : [String:String]? = nil
        if(numberTarget == 1) {
            targetEvaluation = [
                "target1" : target1.text!,
                "result1" : result1.text!,
                "numberTarget" : String(numberTarget)
            ]
        } else if(numberTarget == 2) {
            targetEvaluation = [
                "target1" : target1.text!,
                "result1" : result1.text!,
                "target2" : target2.text!,
                "result2" : result2.text!,
                "numberTarget" : String(numberTarget)
            ]
        }
        
        else if(numberTarget == 3) {
            targetEvaluation = [
                "target1" : target1.text!,
                "result1" : result1.text!,
                "target2" : target2.text!,
                "result2" : result2.text!,
                "target3" : target3.text!,
                "result3" : result3.text!,
                "numberTarget" : String(numberTarget)
            ]
        }
        
        DatabaseUtil.addValueInDataBase(valueToAdd: targetEvaluation!,collectionToCreate: "targetEvaluation")
    }
    
    private func updateValueInDB(){
        var targetEvaluation : [String:String]? = nil
        if(numberTarget == 1) {
            targetEvaluation = [
                "target1" : target1.text!,
                "result1" : result1.text!,
                "numberTarget" : String(numberTarget)
            ]
        } else if(numberTarget == 2) {
            targetEvaluation = [
                "target1" : target1.text!,
                "result1" : result1.text!,
                "target2" : target2.text!,
                "result2" : result2.text!,
                "numberTarget" : String(numberTarget)
            ]
        }
        
        else if(numberTarget == 3) {
            targetEvaluation = [
                "target1" : target1.text!,
                "result1" : result1.text!,
                "target2" : target2.text!,
                "result2" : result2.text!,
                "target3" : target3.text!,
                "result3" : result3.text!,
                "numberTarget" : String(numberTarget)
            ]
        }
        
        
        DatabaseUtil.updateValueInDataBase(valueToUpdate: targetEvaluation!,collectionToUpdate: "targetEvaluation",documentUpdateId: documentUpdateId)
    }
    
    
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("targetEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.get("numberTarget") != nil) {
                        self.numberTarget = Int((document.get("numberTarget") as! String))!
                    }
                    print("numberTarget : \(self.numberTarget)")
                    if (self.numberTarget == 1) {
                        if (document.get("target1") != nil) {
                            self.target1.text = (document.get("target1") as! String)
                        }
                        if (document.get("result1") != nil) {
                            self.result1.text = (document.get("result1") as! String)
                        }
                    } else if (self.numberTarget == 2) {
                        if (document.get("target1") != nil) {
                            self.target1.text = (document.get("target1") as! String)
                        }
                        if (document.get("result1") != nil) {
                            self.result1.text = (document.get("result1") as! String)
                        }
                        if (document.get("target2") != nil) {
                            self.target2.text = (document.get("target2") as! String)
                        }
                        if (document.get("result2") != nil) {
                            self.result2.text = (document.get("result2") as! String)
                        }
                    }
                    else if (self.numberTarget == 3) {
                        if (document.get("target1") != nil) {
                            self.target1.text = (document.get("target1") as! String)
                        }
                        if (document.get("result1") != nil) {
                            self.result1.text = (document.get("result1") as! String)
                        }
                        if (document.get("target2") != nil) {
                            self.target2.text = (document.get("target2") as! String)
                        }
                        if (document.get("result2") != nil) {
                            self.result2.text = (document.get("result2") as! String)
                        }
                        if (document.get("target3") != nil) {
                            self.target3.text = (document.get("target3") as! String)
                        }
                        if (document.get("result3") != nil) {
                            self.result3.text = (document.get("result3") as! String)
                        }
                    }
                    
                    self.updateTargetView()
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
extension TargetEvaluationViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.activeField?.resignFirstResponder()
        self.activeField = nil
        return true
    }
}


// MARK: Keyboard Handling
extension TargetEvaluationViewController {
    
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
