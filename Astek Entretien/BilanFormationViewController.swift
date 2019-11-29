//
//  BilanFormationViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 28/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase
class BilanFormationViewController: UIViewController {
    
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint!
    private var keyboardHeight: CGFloat!
    private var updateValue = false
    private var documentUpdateId = ""
    private var className: String = ""
    private var numberTarget = 1
    private var buttonValue1 = ""
    private var buttonValue2 = ""
    
    //First Bilan
    @IBOutlet weak var entitled1: UITextField!
    @IBOutlet weak var date1: UITextField!
    @IBOutlet weak var duration1: UITextField!
    @IBOutlet weak var implementation1: UITextField!
    @IBOutlet weak var employerButton1: UIButton!
    @IBOutlet weak var employeeButton1: UIButton!
    @IBOutlet weak var commentary1: UITextField!
    
    //entitled2 Stack View
    @IBOutlet weak var entitledStackView2: UIStackView!
    @IBOutlet weak var entitledTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var entitledStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var entitled2: UITextField!
    
    //Date2 Stack View
    @IBOutlet weak var dateStackView2: UIStackView!
    @IBOutlet weak var dateTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var dateStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var date2: UITextField!
    
    //Duration2 Stack View
    @IBOutlet weak var durationStackView2: UIStackView!
    @IBOutlet weak var durationTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var durationStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var duration2: UITextField!
    
    //Initiative2 Stack View
    @IBOutlet weak var initiativeStackView2: UIStackView!
    @IBOutlet weak var initiativeTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var initiativeStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var employeeButton2: UIButton!
    @IBOutlet weak var employerButton2: UIButton!
    
    //Implementation2 Stack View
    @IBOutlet weak var implementationStackView2: UIStackView!
    @IBOutlet weak var implementationTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var implementationStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var implementation2: UITextField!
    
    //Commentary2 Stack View
    @IBOutlet weak var commentaryStackView2: UIStackView!
    @IBOutlet weak var commentaryTopConstraint2: NSLayoutConstraint!
    @IBOutlet weak var commentaryStackViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var commentary2: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initText()
        initSwipeGesture()
        
        className = NSStringFromClass(BilanFormationViewController.classForCoder())
        className = className.replacingOccurrences(of: "Astek_Entretien.", with: "")
        print("TITI className : \(className)")
        
        
        pageNumber.text = "Page \(UIUtil.getCurrentPage(className: className)) / \(UIUtil.getTotalPage())"
        
        employerButton1.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        employeeButton1.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        employerButton2.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        employeeButton2.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
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
        if sender === employerButton1 {
            buttonValue1 = "Employeur"
            employeeButton1.isSelected = false
        } else if sender === employeeButton1 {
            buttonValue1 = "Salarié"
            employerButton1.isSelected = false
        } else if sender === employerButton2 {
            buttonValue2 = "Employeur"
            employeeButton2.isSelected = false
        } else if sender === employeeButton2 {
            buttonValue2 = "Employeur"
            employerButton2.isSelected = false
        }
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
        entitled1.delegate = self
        UIUtil.setBottomBorder(textField: entitled1)
        date1.delegate = self
        UIUtil.setBottomBorder(textField: date1)
        duration1.delegate = self
        UIUtil.setBottomBorder(textField: duration1)
        implementation1.delegate = self
        UIUtil.textAlign(textField: implementation1)
        commentary1.delegate = self
        UIUtil.textAlign(textField: commentary1)
        
        entitled2.delegate = self
        UIUtil.setBottomBorder(textField: entitled2)
        date2.delegate = self
        UIUtil.setBottomBorder(textField: date2)
        duration2.delegate = self
        UIUtil.setBottomBorder(textField: duration2)
        implementation2.delegate = self
        UIUtil.textAlign(textField: implementation2)
        commentary2.delegate = self
        UIUtil.textAlign(textField: commentary2)
        
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
            entitledStackView2.isHidden = true
            entitledTopConstraint2.constant = 0
            entitledStackViewHeight2.constant = 0
            
            dateStackView2.isHidden = true
            dateTopConstraint2.constant = 0
            dateStackViewHeight2.constant = 0
            
            durationStackView2.isHidden = true
            durationTopConstraint2.constant = 0
            durationStackViewHeight2.constant = 0
            
            
            initiativeStackView2.isHidden = true
            initiativeTopConstraint2.constant = 0
            initiativeStackViewHeight2.constant = 0
            
            implementationStackView2.isHidden = true
            implementationTopConstraint2.constant = 0
            implementationStackViewHeight2.constant = 0
            
            commentaryStackView2.isHidden = true
            commentaryTopConstraint2.constant = 0
            commentaryStackViewHeight2.constant = 0
            
            constraintContentHeight.constant = 0
            break
            
        case 2:
            entitledStackView2.isHidden = false
            entitledTopConstraint2.constant = 20
            entitledStackViewHeight2.constant = 30
            
            dateStackView2.isHidden = false
            dateTopConstraint2.constant = 10
            dateStackViewHeight2.constant = 30
            
            durationStackView2.isHidden = false
            durationTopConstraint2.constant = 10
            durationStackViewHeight2.constant = 30
            
            initiativeStackView2.isHidden = false
            initiativeTopConstraint2.constant = 10
            initiativeStackViewHeight2.constant = 35
            
            implementationStackView2.isHidden = false
            implementationTopConstraint2.constant = 20
            implementationStackViewHeight2.constant = 150
            
            commentaryStackView2.isHidden = false
            commentaryTopConstraint2.constant = 20
            commentaryStackViewHeight2.constant = 110
            
            constraintContentHeight.constant = 480
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
        DatabaseUtil.addValueInDataBase(valueToAdd: generateValueForDB(),collectionToCreate: "bilanFormation")
    }
    
    
    private func updateValueInDB(){
        DatabaseUtil.updateValueInDataBase(valueToUpdate: generateValueForDB(),collectionToUpdate: "bilanFormation",documentUpdateId: documentUpdateId)
    }
    
    
    private func retrieveData() {
        let db = Firestore.firestore()
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("bilanFormation").getDocuments() { (querySnapshot, err) in
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
        if (document.get("entitled1") != nil) {
            self.entitled1.text = (document.get("entitled1") as! String)
        }
        if (document.get("date1") != nil) {
            self.date1.text = (document.get("date1") as! String)
        }
        if (document.get("duration1") != nil) {
            self.duration1.text = (document.get("duration1") as! String)
        }
        if (document.get("initiative1") != nil) {
            self.checkedButton1(value: (document.get("initiative1") as! String))
        }
        
        if (document.get("implementation1") != nil) {
            self.implementation1.text = (document.get("implementation1") as! String)
        }
        if (document.get("commentary1") != nil) {
            self.commentary1.text = (document.get("commentary1") as! String)
        }
    }
    
    
    private func retrieveSecondValue(document: DocumentSnapshot) {
        if (document.get("entitled2") != nil) {
            self.entitled2.text = (document.get("entitled2") as! String)
        }
        if (document.get("date2") != nil) {
            self.date2.text = (document.get("date2") as! String)
        }
        if (document.get("duration2") != nil) {
            self.duration2.text = (document.get("duration2") as! String)
        }
        if (document.get("initiative2") != nil) {
            self.checkedButton2(value: (document.get("initiative2") as! String))
        }
        
        if (document.get("implementation2") != nil) {
            self.implementation2.text = (document.get("implementation2") as! String)
        }
        if (document.get("commentary2") != nil) {
            self.commentary2.text = (document.get("commentary2") as! String)
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
            if(entitled1.text == "" || date1.text == "" || duration1.text == "" || buttonValue1 == "" || implementation1.text == "" || commentary1.text == "") {
                UIUtil.showMessage(text: StringValues.errorNoInput)
            } else {
                goNextPage()
            }
            
        case 2:
            if(entitled1.text == "" || date1.text == "" || duration1.text == "" || buttonValue1 == "" || implementation1.text == "" || commentary1.text == ""
                || entitled2.text == "" || date2.text == "" || duration2.text == "" || buttonValue2 == "" || implementation2.text == "" || commentary2.text == ""){
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
                "entitled1" : entitled1.text!,
                "date1" : date1.text!,
                "duration1" : duration1.text!,
                "initiative1" : buttonValue1,
                "implementation1" : implementation1.text!,
                "commentary1" : commentary1.text!,
                "numberTarget" : String(numberTarget)
            ]
        } else if(numberTarget == 2) {
            bilanFormation = [
                "entitled1" : entitled1.text!,
                "date1" : date1.text!,
                "duration1" : duration1.text!,
                "initiative1" : buttonValue1,
                "implemenation1" : implementation1.text!,
                "commentary1" : commentary1.text!,
                
                "entitled2" : entitled2.text!,
                "date2" : date2.text!,
                "duration2" : duration2.text!,
                "initiative2" : buttonValue2,
                "implementation2" : implementation2.text!,
                "commentary2" : commentary2.text!,
                
                "numberTarget" : String(numberTarget)
            ]
        }
        return bilanFormation!
    }
    
    private func checkedButton1(value: String){
        buttonValue1 = value
        if(value == "Employeur") {
            employerButton1.isSelected = true
        }
        if(value == "Salarié") {
            employeeButton1.isSelected = true
        }
    }
    
    private func checkedButton2(value: String){
        buttonValue2 = value
        if(value == "Employeur") {
            employerButton2.isSelected = true
        }
        if(value == "Salarié") {
            employeeButton2.isSelected = true
        }
    }
    
    
    
    
}




// MARK: UITextFieldDelegate
extension BilanFormationViewController: UITextFieldDelegate {
    
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
extension BilanFormationViewController {
    
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
