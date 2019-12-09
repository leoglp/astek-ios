//
//  AutonomousSkillViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 26/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase

class RespectSkillViewController: UIViewController {
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    
    //Skill
    @IBOutlet weak var employeeGrad1: UITextField!
    @IBOutlet weak var managerGrad1: UITextField!
    @IBOutlet weak var example1: UITextField!
    @IBOutlet weak var improvement1: UITextField!
    @IBOutlet weak var managerTitle1: UILabel!
    
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var infoButton1: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initText()
        initSwipeGesture()
        
        className = NSStringFromClass(RespectSkillViewController.classForCoder())
        className = className.replacingOccurrences(of: "Astek_Entretien.", with: "")
        print("TITI className : \(className)")
        
        
        pageNumber.text = "Page \(UIUtil.getCurrentPage(className: className)) / \(UIUtil.getTotalPage())"
        
        infoButton1.addTarget(self, action: #selector(showInfo(_:)), for: .touchUpInside)
        
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
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
        if (sender.direction == .left)
        {
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
        employeeGrad1.delegate = self
        managerGrad1.delegate = self
        example1.delegate = self
        improvement1.delegate = self
        
        SkillUtil.initText(employeeGrad1: employeeGrad1, managerGrad1: managerGrad1,
                           example1: example1, improvement1: improvement1)
        
        if(AuthenticationUtil.isManager) {
            managerTitle1.textColor = UIColor.darkGray
        }
    }
    
    private func createValueInDB(){
        DatabaseUtil.addValueInDataBase(valueToAdd: generateValueForDB(),collectionToCreate: "respectSkillEvaluation")
    }
    
    
    private func updateValueInDB(){
        DatabaseUtil.updateValueInDataBase(valueToUpdate: generateValueForDB(),collectionToUpdate: "respectSkillEvaluation",documentUpdateId: documentUpdateId)
    }
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("respectSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
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
        if(AuthenticationUtil.isManager) {
            if(employeeGrad1.text == "" || managerGrad1.text == "" || example1.text == "" || improvement1.text == "") {
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                checkNumberValue()
            }
        } else {
            if(employeeGrad1.text == "" || example1.text == ""){
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                checkNumberValue()
            }
        }
    }
    
    
    private func checkNumberValue(){
        if(SkillUtil.checkNumberValueOK(employeeGrad1: employeeGrad1, managerGrad1: managerGrad1)) {
            goNextPage()
        } else {
            UIUtil.showMessage(text: StringValues.errorGraduation)
        }
    }
    
    private func goNextPage(){
        createOrUpdate()
        UIUtil.goToNextPage(className: className, controller: self)
    }
    
    
    private func generateValueForDB() -> [String:String] {
        let skillEvaluation = [
            "employeeGraduation1" : employeeGrad1.text!,
            "managerGraduation1" : managerGrad1.text!,
            "skillExample1" : example1.text!,
            "improvementAndGain1" : improvement1.text!
        ]
        
        return skillEvaluation
    }
    
}







// MARK: UITextFieldDelegate
extension RespectSkillViewController: UITextFieldDelegate {
    
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
extension RespectSkillViewController {
    
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

