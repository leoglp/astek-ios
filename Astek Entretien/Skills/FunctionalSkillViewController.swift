//
//  FunctionnalSkillViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 25/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase

class FunctionalSkillViewController: UIViewController {
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    private var numberTarget = 1
    
    
    //First Skill
    @IBOutlet weak var skill1: UITextField!
    @IBOutlet weak var employeeGrad1: UITextField!
    @IBOutlet weak var managerGrad1: UITextField!
    @IBOutlet weak var example1: UITextField!
    @IBOutlet weak var improvement1: UITextField!
    
    //Skill2 Stack View
    @IBOutlet weak var skillStackView2: UIStackView!
    @IBOutlet weak var skillTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var skillStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var skill2: UITextField!
    
    //EmployeeGraduation2 Stack View
    @IBOutlet weak var employeeGradStackView2: UIStackView!
    @IBOutlet weak var employeeGradTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var employeeGradStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var employeeGrad2: UITextField!
    
    //ManagerGraduation2 Stack View
    @IBOutlet weak var managerGradStackView2: UIStackView!
    @IBOutlet weak var managerGradTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var managerGradStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var managerGrad2: UITextField!
    
    //Example2 Stack View
    @IBOutlet weak var exampleStackView2: UIStackView!
    @IBOutlet weak var exampleTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var exampleStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var example2: UITextField!
    
    //Improvement2 Stack View
    @IBOutlet weak var improvementStackView2: UIStackView!
    @IBOutlet weak var improvementTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var improvementStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var improvement2: UITextField!
    
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
    
    @IBOutlet weak var infoButton1: UIButton!
    @IBOutlet weak var infoButton2: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initText()
        
        className = NSStringFromClass(FunctionalSkillViewController.classForCoder())
        className = className.replacingOccurrences(of: "Astek_Entretien.", with: "")
        print("TITI className : \(className)")
        
        
        pageNumber.text = "Page \(UIUtil.getCurrentPage(className: className)) / \(UIUtil.getTotalPage())"
        
        infoButton1.addTarget(self, action: #selector(showInfo(_:)), for: .touchUpInside)
        infoButton2.addTarget(self, action: #selector(showInfo(_:)), for: .touchUpInside)
        
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
    
    @objc func showInfo(_ sender: UIButton) {
        UIUtil.showMessage(text: StringValues.graduationInfo)
    }
    
    private func initText() {
        skill1.delegate = self
        UIUtil.textAlign(textField: skill1)
        employeeGrad1.delegate = self
        UIUtil.textAlign(textField: employeeGrad1)
        UIUtil.setBottomBorder(textField: employeeGrad1)
        managerGrad1.delegate = self
        UIUtil.textAlign(textField: managerGrad1)
        UIUtil.setBottomBorder(textField: managerGrad1)
        example1.delegate = self
        UIUtil.textAlign(textField: example1)
        improvement1.delegate = self
        UIUtil.textAlign(textField: improvement1)
        
        skill2.delegate = self
        UIUtil.textAlign(textField: skill2)
        employeeGrad2.delegate = self
        UIUtil.textAlign(textField: employeeGrad2)
        UIUtil.setBottomBorder(textField: employeeGrad2)
        managerGrad2.delegate = self
        UIUtil.textAlign(textField: managerGrad2)
        UIUtil.setBottomBorder(textField: managerGrad2)
        example2.delegate = self
        UIUtil.textAlign(textField: example2)
        improvement2.delegate = self
        UIUtil.textAlign(textField: improvement2)
        
        
        
        if(!AuthenticationUtil.isManager) {
            UIUtil.textBottomBorderDisabled(textField: managerGrad1)
            UIUtil.textDisabled(textField: improvement1)
            UIUtil.textBottomBorderDisabled(textField: managerGrad2)
            UIUtil.textDisabled(textField: improvement2)
        }
    }
    
    
    private func updateTargetView(){
        
        switch numberTarget {
        case 1:
            skillStackView2.isHidden = true
            skillTopConstraint2.constant = 0
            skillStackViewHeight2.constant = 0
            
            employeeGradStackView2.isHidden = true
            employeeGradTopConstraint2.constant = 0
            employeeGradStackViewHeight2.constant = 0
            
            managerGradStackView2.isHidden = true
            managerGradTopConstraint2.constant = 0
            managerGradStackViewHeight2.constant = 0
            
            exampleStackView2.isHidden = true
            exampleTopConstraint2.constant = 0
            exampleStackViewHeight2.constant = 0
            
            improvementStackView2.isHidden = true
            improvementTopConstraint2.constant = 0
            improvementStackViewHeight2.constant = 0
            
            constraintContentHeight.constant = 0
            break
            
        case 2:
            skillStackView2.isHidden = false
            skillTopConstraint2.constant = 20
            skillStackViewHeight2.constant = 70
            
            employeeGradStackView2.isHidden = false
            employeeGradTopConstraint2.constant = 15
            employeeGradStackViewHeight2.constant = 30
            
            managerGradStackView2.isHidden = false
            managerGradTopConstraint2.constant = 15
            managerGradStackViewHeight2.constant = 30
            
            exampleStackView2.isHidden = false
            exampleTopConstraint2.constant = 15
            exampleStackViewHeight2.constant = 70
            
            improvementStackView2.isHidden = false
            improvementTopConstraint2.constant = 15
            improvementStackViewHeight2.constant = 70
            
            constraintContentHeight.constant = 240
            break
            
        default:
            return
        }
        
        UIUtil.updateSkillButton(number: numberTarget,buttonAdd: addButton,buttonDelete: deleteButton)
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
        var skillEvaluation : [String:String]? = nil
        if(numberTarget == 1) {
            skillEvaluation = [
                "skill1" : skill1.text!,
                "employeeGraduation1" : employeeGrad1.text!,
                "managerGraduation1" : managerGrad1.text!,
                "skillExample1" : example1.text!,
                "improvementAndGain1" : improvement1.text!,
                "numberTarget" : String(numberTarget)
            ]
        } else if(numberTarget == 2) {
            skillEvaluation = [
                "skill1" : skill1.text!,
                "employeeGraduation1" : employeeGrad1.text!,
                "managerGraduation1" : managerGrad1.text!,
                "skillExample1" : example1.text!,
                "improvementAndGain1" : improvement1.text!,
                "skill2" : skill2.text!,
                "employeeGraduation2" : employeeGrad2.text!,
                "managerGraduation2" : managerGrad2.text!,
                "skillExample2" : example2.text!,
                "improvementAndGain2" : improvement2.text!,
                "numberTarget" : String(numberTarget)
            ]
        }
        
        DatabaseUtil.addValueInDataBase(valueToAdd: skillEvaluation!,collectionToCreate: "functionalSkillEvaluation")
    }
    
    
    private func updateValueInDB(){
        var skillEvaluation : [String:String]? = nil
        if(numberTarget == 1) {
            skillEvaluation = [
                "skill1" : skill1.text!,
                "employeeGraduation1" : employeeGrad1.text!,
                "managerGraduation1" : managerGrad1.text!,
                "skillExample1" : example1.text!,
                "improvementAndGain1" : improvement1.text!,
                "numberTarget" : String(numberTarget)
            ]
        } else if(numberTarget == 2) {
            skillEvaluation = [
                "skill1" : skill1.text!,
                "employeeGraduation1" : employeeGrad1.text!,
                "managerGraduation1" : managerGrad1.text!,
                "skillExample1" : example1.text!,
                "improvementAndGain1" : improvement1.text!,
                "skill2" : skill2.text!,
                "employeeGraduation2" : employeeGrad2.text!,
                "managerGraduation2" : managerGrad2.text!,
                "skillExample2" : example2.text!,
                "improvementAndGain2" : improvement2.text!,
                "numberTarget" : String(numberTarget)
            ]
        }
        
        DatabaseUtil.updateValueInDataBase(valueToUpdate: skillEvaluation!,collectionToUpdate: "functionalSkillEvaluation",documentUpdateId: documentUpdateId)
    }
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("functionalSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if (document.get("numberTarget") != nil) {
                        self.numberTarget = Int((document.get("numberTarget") as! String))!
                    }
                    print("numberTarget : \(self.numberTarget)")
                    if (self.numberTarget == 1) {
                        if (document.get("skill1") != nil) {
                            self.skill1.text = (document.get("skill1") as! String)
                        }
                        if (document.get("employeeGraduation1") != nil) {
                            self.employeeGrad1.text = (document.get("employeeGraduation1") as! String)
                        }
                        if (document.get("managerGraduation1") != nil) {
                            self.managerGrad1.text = (document.get("managerGraduation1") as! String)
                        }
                        if (document.get("skillExample1") != nil) {
                            self.example1.text = (document.get("skillExample1") as! String)
                        }
                        if (document.get("improvementAndGain1") != nil) {
                            self.improvement1.text = (document.get("improvementAndGain1") as! String)
                        }
                    } else if (self.numberTarget == 2) {
                        if (document.get("skill1") != nil) {
                            self.skill1.text = (document.get("skill1") as! String)
                        }
                        if (document.get("employeeGraduation1") != nil) {
                            self.employeeGrad1.text = (document.get("employeeGraduation1") as! String)
                        }
                        if (document.get("managerGraduation1") != nil) {
                            self.managerGrad1.text = (document.get("managerGraduation1") as! String)
                        }
                        if (document.get("skillExample1") != nil) {
                            self.example1.text = (document.get("skillExample1") as! String)
                        }
                        if (document.get("improvementAndGain1") != nil) {
                            self.improvement1.text = (document.get("improvementAndGain1") as! String)
                        }
                        if (document.get("skill2") != nil) {
                            self.skill2.text = (document.get("skill2") as! String)
                        }
                        if (document.get("employeeGraduation2") != nil) {
                            self.employeeGrad2.text = (document.get("employeeGraduation2") as! String)
                        }
                        if (document.get("managerGraduation2") != nil) {
                            self.managerGrad2.text = (document.get("managerGraduation2") as! String)
                        }
                        if (document.get("skillExample2") != nil) {
                            self.example2.text = (document.get("skillExample2") as! String)
                        }
                        if (document.get("improvementAndGain2") != nil) {
                            self.improvement2.text = (document.get("improvementAndGain2") as! String)
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
    
    
    func checkFieldEmpty(){
        switch numberTarget {
        case 1:
            if(AuthenticationUtil.isManager) {
                if(skill1.text == "" || employeeGrad1.text == "" || managerGrad1.text == "" || example1.text == "" || improvement1.text == "") {
                    UIUtil.showMessage(text: StringValues.errorNoInput)
                } else {
                    checkNumberValue()
                }
            } else {
                if(skill1.text == "" || employeeGrad1.text == "" || example1.text == ""){
                    UIUtil.showMessage(text: StringValues.errorNoInput)
                } else {
                    checkNumberValue()
                }
            }
        case 2:
            if(AuthenticationUtil.isManager) {
                if(skill1.text == "" || employeeGrad1.text == "" || managerGrad1.text == "" || example1.text == "" || improvement1.text == ""
                    || skill2.text == "" || employeeGrad2.text == "" || managerGrad2.text == "" || example2.text == "" || improvement2.text == ""){
                    UIUtil.showMessage(text: StringValues.errorNoInput)
                } else {
                    checkNumberValue()
                }
            } else {
                if(skill1.text == "" || employeeGrad1.text == "" || example1.text == ""
                    || skill2.text == "" || employeeGrad2.text == "" || example2.text == ""){
                    UIUtil.showMessage(text: StringValues.errorNoInput)
                } else {
                    checkNumberValue()
                }
            }
        default:
            return
        }
    }
    
    private func checkNumberValue(){
        
        var intEmployeeGrad1 : Int = 0
        if(employeeGrad1.text != "") {
            intEmployeeGrad1 = Int(employeeGrad1.text!)!
        }
        var intManagerGrad1 : Int = 0
        if(managerGrad1.text != "") {
            intManagerGrad1 = Int(managerGrad1.text!)!
        }
        
        var intEmployeeGrad2 : Int = 0
        if(employeeGrad2.text != "") {
            intEmployeeGrad2 = Int(employeeGrad2.text!)!
        }
        var intManagerGrad2 : Int = 0
        if(managerGrad2.text != "") {
            intManagerGrad2 = Int(managerGrad2.text!)!
        }
        
        switch numberTarget {
        case 1:
            if(AuthenticationUtil.isManager) {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intManagerGrad1 == 1 || intManagerGrad1 == 2 || intManagerGrad1 == 3 || intManagerGrad1 == 4)) {
                    goNextPage()
                } else {
                    UIUtil.showMessage(text: StringValues.errorGraduation)
                }
            } else {
                if(intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4) {
                    goNextPage()
                } else {
                    UIUtil.showMessage(text: StringValues.errorGraduation)
                }
            }
        case 2:
            if(AuthenticationUtil.isManager) {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intManagerGrad1 == 1 || intManagerGrad1 == 2 || intManagerGrad1 == 3 || intManagerGrad1 == 4)
                    && (intEmployeeGrad2 == 1 || intEmployeeGrad2 == 2 || intEmployeeGrad2 == 3 || intEmployeeGrad2 == 4)
                    && (intManagerGrad2 == 1 || intManagerGrad2 == 2 || intManagerGrad2 == 3 || intManagerGrad2 == 4)) {
                    goNextPage()
                } else {
                    UIUtil.showMessage(text: StringValues.errorGraduation)
                }
            } else {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intEmployeeGrad2 == 1 || intEmployeeGrad2 == 2 || intEmployeeGrad2 == 3 || intEmployeeGrad2 == 4)){
                    goNextPage()
                } else {
                    UIUtil.showMessage(text: StringValues.errorGraduation)
                }
            }
        default:
            return
        }
    }
    
    private func goNextPage(){
        createOrUpdate()
        UIUtil.goToNextPage(className: className, controller: self)
    }
    
    
    
    
}














// MARK: UITextFieldDelegate
extension FunctionalSkillViewController: UITextFieldDelegate {
    
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
extension FunctionalSkillViewController {
    
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