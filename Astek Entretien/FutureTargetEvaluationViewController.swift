//
//  FutureTargetEvaluationViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 21/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase

class FutureTargetEvaluationViewController: UIViewController {
    
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    private var numberTarget = 1
    
    
    //Target1 Stack View
    @IBOutlet weak var target1: UITextField!
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
        checkFieldEmpty()
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
    
    @IBAction func settingsAction(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initText()
        initSwipeGesture()
        
        className = NSStringFromClass(FutureTargetEvaluationViewController.classForCoder())
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
        if (sender.direction == .left){
            checkFieldEmpty()
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
        print(numberTarget)
        switch numberTarget {
        case 1:
            targetStackView2.isHidden = true
            targetStackViewHeight2.constant = 0
            targetTopConstraint2.constant = 0
            
            resultStackView2.isHidden = true
            resultStackViewHeight2.constant = 0
            resultTopConstraint2.constant = 0
            
            targetStackView3.isHidden = true
            targetStackViewHeight3.constant = 0
            targetTopConstraint3.constant = 0
            
            resultStackView3.isHidden = true
            resultStackViewHeight3.constant = 0
            resultTopConstraint3.constant = 0
            
            constraintContentHeight.constant = 0
            
            UIUtil.updateButtonForThreeValues(number: numberTarget, constraintContentHeight: constraintContentHeight, constraintContentHeightValue: 0, isManager: AuthenticationUtil.isManager, stackView: buttonStackView, bottomConstraint1: buttonBottomConstraint, heightConstraint1: buttonBottomConstraint, buttonAdd: addButton, buttonDelete: deleteButton)
        case 2:
            targetStackView2.isHidden = false
            targetStackViewHeight2.constant = 130
            targetTopConstraint2.constant = 20
            
            resultStackView2.isHidden = false
            resultStackViewHeight2.constant = 130
            resultTopConstraint2.constant = 15
            
            targetStackView3.isHidden = true
            targetStackViewHeight3.constant = 0
            targetTopConstraint3.constant = 0
            
            resultStackView3.isHidden = true
            resultStackViewHeight3.constant = 0
            resultTopConstraint3.constant = 0
            
            constraintContentHeight.constant = 215
            
            UIUtil.updateButtonForThreeValues(number: numberTarget, constraintContentHeight: constraintContentHeight, constraintContentHeightValue: 175, isManager: AuthenticationUtil.isManager, stackView: buttonStackView, bottomConstraint1: buttonBottomConstraint, heightConstraint1: buttonBottomConstraint, buttonAdd: addButton, buttonDelete: deleteButton)
        case 3:
            targetStackView2.isHidden = false
            targetStackViewHeight2.constant = 130
            targetTopConstraint2.constant = 20
            
            resultStackView2.isHidden = false
            resultStackViewHeight2.constant = 130
            resultTopConstraint2.constant = 15
            
            targetStackView3.isHidden = false
            targetStackViewHeight3.constant = 130
            targetTopConstraint3.constant = 20
            
            resultStackView3.isHidden = false
            resultStackViewHeight3.constant = 130
            resultTopConstraint3.constant = 15
            
            constraintContentHeight.constant = 520
            
            UIUtil.updateButtonForThreeValues(number: numberTarget, constraintContentHeight: constraintContentHeight, constraintContentHeightValue: 490, isManager: AuthenticationUtil.isManager, stackView: buttonStackView, bottomConstraint1: buttonBottomConstraint, heightConstraint1: buttonBottomConstraint, buttonAdd: addButton, buttonDelete: deleteButton)
        default:
            return
        }
        
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
        DatabaseUtil.addValueInDataBase(valueToAdd: generateValueForDB(),collectionToCreate: "futureTargetEvaluation")
    }
    
    private func updateValueInDB(){
        DatabaseUtil.updateValueInDataBase(valueToUpdate: generateValueForDB(),collectionToUpdate: "futureTargetEvaluation",documentUpdateId: documentUpdateId)
    }
    
    
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("futureTargetEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.get("numberTarget") != nil) {
                        self.numberTarget = Int((document.get("numberTarget") as! String))!
                    }
                    if (self.numberTarget == 1) {
                        self.retrieveFirstValue(document: document)
                    } else if (self.numberTarget == 2) {
                        self.retrieveFirstValue(document: document)
                        self.retrieveSecondValue(document: document)
                    }
                    else if (self.numberTarget == 3) {
                        self.retrieveFirstValue(document: document)
                        self.retrieveSecondValue(document: document)
                        self.retrieveThirdValue(document: document)
                    }
                    
                    self.updateTargetView()
                    self.updateValue = true
                    self.documentUpdateId = document.documentID
                }
            }
        }
    }
    
    private func retrieveFirstValue(document: DocumentSnapshot) {
        if (document.get("target1") != nil) {
            self.target1.text = (document.get("target1") as! String)
        }
        if (document.get("result1") != nil) {
            self.result1.text = (document.get("result1") as! String)
        }
    }
    
    private func retrieveSecondValue(document: DocumentSnapshot) {
        if (document.get("target2") != nil) {
            self.target2.text = (document.get("target2") as! String)
        }
        if (document.get("result2") != nil) {
            self.result2.text = (document.get("result2") as! String)
        }
    }
    
    private func retrieveThirdValue(document: DocumentSnapshot) {
        if (document.get("target3") != nil) {
            self.target3.text = (document.get("target3") as! String)
        }
        if (document.get("result3") != nil) {
            self.result3.text = (document.get("result3") as! String)
        }
    }
    
    private func generateValueForDB() -> [String:String] {
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
        
        return targetEvaluation!
    }
    
    
    private func createOrUpdate(){
        if(updateValue){
            updateValueInDB()
        } else {
            createValueInDB()
        }
    }
    
    
    private func checkFieldEmpty(){
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
    
    
    
}




// MARK: UITextFieldDelegate
extension FutureTargetEvaluationViewController: UITextFieldDelegate {
    
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
extension FutureTargetEvaluationViewController {
    
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
