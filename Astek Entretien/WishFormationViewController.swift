//
//  BilanFormationViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 28/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase
class WishFormationViewController: UIViewController {
    
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    private var numberTarget = 1
    
    //First Bilan
    @IBOutlet weak var wish1: UITextField!
    @IBOutlet weak var targetFormation1: UITextField!
    @IBOutlet weak var motivation1: UITextField!
    @IBOutlet weak var modality1: UITextField!
    
    //Wish2 Stack View
    @IBOutlet weak var wishStackView2: UIStackView!
    @IBOutlet weak var wishTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var wishStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var wish2: UITextField!
    
    //TargetFormation2 Stack View
    @IBOutlet weak var targetFormationStackView2: UIStackView!
    @IBOutlet weak var targetFormationTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var targetFormationStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var targetFormation2: UITextField!
    
      //Motivation2 Stack View
    @IBOutlet weak var motivationStackView2: UIStackView!
    @IBOutlet weak var motivationTopConstraint2: NSLayoutConstraint!
       @IBOutlet weak var motivationStackViewHeight2: NSLayoutConstraint!
       @IBOutlet weak var motivation2: UITextField!
    
    //Modality2 Stack View
    @IBOutlet weak var modalityStackView2: UIStackView!
    @IBOutlet weak var modalityTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var modalityStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var modality2: UITextField!
    
    
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
        
        className = NSStringFromClass(WishFormationViewController.classForCoder())
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
        
        if (sender.direction == .right){
            createOrUpdate()
            UIUtil.goToPreviousPage(className: className, controller: self)
        }
    }
    
    
    private func initText() {
        wish1.delegate = self
        UIUtil.textAlign(textField: wish1)
        targetFormation1.delegate = self
        UIUtil.textAlign(textField: targetFormation1)
        motivation1.delegate = self
        UIUtil.textAlign(textField: motivation1)
        modality1.delegate = self
        UIUtil.textAlign(textField: modality1)
        
        
        wish2.delegate = self
        UIUtil.textAlign(textField: wish2)
        targetFormation2.delegate = self
        UIUtil.textAlign(textField: targetFormation2)
        motivation2.delegate = self
        UIUtil.textAlign(textField: motivation2)
        modality2.delegate = self
        UIUtil.textAlign(textField: modality2)
        
        if(!AuthenticationUtil.isManager) {
            UIUtil.textDisabled(textField: targetFormation1)
            UIUtil.textDisabled(textField: modality1)

            UIUtil.textDisabled(textField: targetFormation2)
            UIUtil.textDisabled(textField: modality2)

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
    
    
    
    private func updateTargetView(){
        
        switch numberTarget {
        case 1:
            wishStackView2.isHidden = true
            wishTopConstraint2.constant = 0
            wishStackViewHeight2.constant = 0
            
            targetFormationStackView2.isHidden = true
            targetFormationTopConstraint2.constant = 0
            targetFormationStackViewHeight2.constant = 0
            
            motivationStackView2.isHidden = true
            motivationTopConstraint2.constant = 0
            motivationStackViewHeight2.constant = 0
            
            
            modalityStackView2.isHidden = true
            modalityTopConstraint2.constant = 0
             modalityStackViewHeight2.constant = 0
            
            constraintContentHeight.constant = 0
            break
            
        case 2:
            wishStackView2.isHidden = false
            wishTopConstraint2.constant = 20
             wishStackViewHeight2.constant = 90
             
             targetFormationStackView2.isHidden = false
             targetFormationTopConstraint2.constant = 15
             targetFormationStackViewHeight2.constant = 90
             
             motivationStackView2.isHidden = false
             motivationTopConstraint2.constant = 15
             motivationStackViewHeight2.constant = 90
             
            modalityStackView2.isHidden = false
            modalityTopConstraint2.constant = 15
            modalityStackViewHeight2.constant = 120
             
             constraintContentHeight.constant = 470
        break
            
        default:
            return
        }
        
        SkillUtil.updateSkillButtonForTwoSkills(number: numberTarget,buttonAdd: addButton,buttonDelete: deleteButton)
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
        DatabaseUtil.addValueInDataBase(valueToAdd: generateValueForDB(),collectionToCreate: "wishFormation")
    }
    
    
    private func updateValueInDB(){
        DatabaseUtil.updateValueInDataBase(valueToUpdate: generateValueForDB(),collectionToUpdate: "wishFormation",documentUpdateId: documentUpdateId)
    }
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("wishFormation").getDocuments() { (querySnapshot, err) in
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
                    
                    self.updateTargetView()
                    self.updateValue = true
                    self.documentUpdateId = document.documentID
                }
            }
        }
    }
    
    
    private func retrieveFirstValue(document: DocumentSnapshot) {
        if (document.get("wish1") != nil) {
            self.wish1.text = (document.get("wish1") as! String)
        }
        if (document.get("target1") != nil) {
            self.targetFormation1.text = (document.get("target1") as! String)
        }
        if (document.get("motivation1") != nil) {
            self.motivation1.text = (document.get("motivation1") as! String)
        }
        if (document.get("modality1") != nil) {
            self.modality1.text = (document.get("modality1") as! String)
        }
    }
    
    
    private func retrieveSecondValue(document: DocumentSnapshot) {
        if (document.get("wish2") != nil) {
                   self.wish2.text = (document.get("wish2") as! String)
               }
               if (document.get("target2") != nil) {
                   self.targetFormation2.text = (document.get("target2") as! String)
               }
               if (document.get("motivation2") != nil) {
                   self.motivation2.text = (document.get("motivation2") as! String)
               }
               if (document.get("modality2") != nil) {
                   self.modality2.text = (document.get("modality2") as! String)
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
            if(wish1.text == "" || targetFormation1.text == "" || motivation1.text == ""
            || modality1.text == "") {
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                goNextPage()
            }
            
        case 2:
            if(wish1.text == "" || targetFormation1.text == "" || motivation1.text == ""
                || modality1.text == ""
                || wish2.text == "" || targetFormation2.text == "" || motivation2.text == ""
                || modality2.text == "" ){
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                goNextPage()
            }
        default:
            return
        }
    }
    
    private func goNextPage(){
        createOrUpdate()
        UIUtil.goToNextPage(className: className, controller: self)
    }
    
    
    private func generateValueForDB() -> [String:String] {
        var bilanFormation : [String:String]?
        if(numberTarget == 1) {
            bilanFormation = [
                "wish1" : wish1.text!,
                "target1" : targetFormation1.text!,
                "motivation1" : motivation1.text!,
                "modality1" : modality1.text!,
                "numberTarget" : String(numberTarget)
            ]
        } else if(numberTarget == 2) {
            bilanFormation = [
                 "wish1" : wish1.text!,
                               "target1" : targetFormation1.text!,
                               "motivation1" : motivation1.text!,
                               "modality1" : modality1.text!,
                
                "wish2" : wish2.text!,
                               "target2" : targetFormation2.text!,
                               "motivation2" : motivation2.text!,
                               "modality2" : modality2.text!,
                
                "numberTarget" : String(numberTarget)
            ]
        }
        return bilanFormation!
    }
   
    
    
    
}




// MARK: UITextFieldDelegate
extension WishFormationViewController: UITextFieldDelegate {
    
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
extension WishFormationViewController {
    
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
