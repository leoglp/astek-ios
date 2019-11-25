//
//  UIUtil.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 15/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import Firebase

class UIUtil {
    
    static func showMessage(text: String) {
        let message = MDCSnackbarMessage()
        message.text = text
        MDCSnackbarManager.show(message)
    }
    
    static func setBottomBorder(textField: UITextField) {
        textField.borderStyle = .none
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowRadius = 0.0
    }
    
    static func goToPage(pageNumber: Int , controller: UIViewController) {
        print("TITI goToPage : \(pageNumber)")
        DatabaseUtil.updatePageValue(pageNumber: String(pageNumber))
        switch pageNumber {
        case -1:
            controller.performSegue(withIdentifier: "showManager", sender: nil)
        case 0:
            controller.performSegue(withIdentifier: "showFirstPage", sender: nil)
        case 1:
            controller.performSegue(withIdentifier: "showInterview", sender: nil)
        case 2:
            controller.performSegue(withIdentifier: "showBilanMission", sender: nil)
        case 3:
            controller.performSegue(withIdentifier: "showEmployeeAppreciation", sender: nil)
        case 4:
            controller.performSegue(withIdentifier: "showManagerAppreciation", sender: nil)
        case 5:
            controller.performSegue(withIdentifier: "showTargetEvaluation", sender: nil)
        case 6:
            controller.performSegue(withIdentifier: "showPerformanceEvaluation", sender: nil)
        case 7:
            controller.performSegue(withIdentifier: "showTechnicalSkill", sender: nil)
        case 8:
            controller.performSegue(withIdentifier: "showProfessionSkill", sender: nil)
        case 9:
            controller.performSegue(withIdentifier: "showFunctionnalSkill", sender: nil)
        default:
            return
        }
    }
    
    static func getCurrentPage(className: String) -> Int {
        print(className)
        return ArrayValues.classValues.firstIndex(of: className)! + 1
    }
    
    static func getTotalPage() -> Int {
        return ArrayValues.classValues.capacity
    }
    
    static func goToNextPage(className: String, controller: UIViewController){
        let index = ArrayValues.classValues.firstIndex(of: className)! + 2
        goToPage(pageNumber: index, controller: controller)
    }
    
    static func goToPreviousPage(className: String, controller: UIViewController){
        let index = ArrayValues.classValues.firstIndex(of: className)!
        goToPage(pageNumber: index, controller: controller)
    }
    
    static func backToHome(controller: UIViewController) {
        try! Auth.auth().signOut()
        controller.performSegue(withIdentifier: "showFirstPage", sender: nil)
    }
    
    static func textAlign(textField: UITextField) {
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .top
    }
    
    static func textDisabled(textField: UITextField) {
        textField.isEnabled = false
        textField.backgroundColor = UIColor.gray
    }
    
    static func textBottomBorderDisabled(textField: UITextField) {
        textField.isEnabled = false
        textField.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    static func updateViewForThreeValues(number: Int,
                                         constraintContentHeight: NSLayoutConstraint!,
                                         stackView1: UIStackView,
                                         topConstraint1: NSLayoutConstraint!,
                                         heightConstraint1: NSLayoutConstraint!,
                                         stackView2: UIStackView,
                                         topConstraint2: NSLayoutConstraint!,
                                         heightConstraint2: NSLayoutConstraint!,
                                         stackView3: UIStackView,
                                         topConstraint3: NSLayoutConstraint!,
                                         heightConstraint3: NSLayoutConstraint!,
                                         stackView4: UIStackView,
                                         topConstraint4: NSLayoutConstraint!,
                                         heightConstraint4: NSLayoutConstraint!) {
        switch number {
        case 1:
            stackView1.isHidden = true
            heightConstraint1.constant = 0
            topConstraint1.constant = 0
            
            stackView2.isHidden = true
            heightConstraint2.constant = 0
            topConstraint2.constant = 0
            
            stackView3.isHidden = true
            heightConstraint3.constant = 0
            topConstraint3.constant = 0
            
            stackView4.isHidden = true
            heightConstraint4.constant = 0
            topConstraint4.constant = 0
            
            constraintContentHeight.constant = 0
        case 2:
            stackView1.isHidden = false
            heightConstraint1.constant = 130
            topConstraint1.constant = 20
            
            stackView2.isHidden = false
            heightConstraint2.constant = 130
            topConstraint2.constant = 15
            
            stackView3.isHidden = true
            heightConstraint3.constant = 0
            topConstraint3.constant = 0
            
            stackView4.isHidden = true
            heightConstraint4.constant = 0
            topConstraint4.constant = 0
            
            constraintContentHeight.constant = 155
        case 3:
            stackView1.isHidden = false
            heightConstraint1.constant = 130
            topConstraint1.constant = 20
            
            stackView2.isHidden = false
            heightConstraint2.constant = 130
            topConstraint2.constant = 15
            
            stackView3.isHidden = false
            heightConstraint3.constant = 130
            topConstraint3.constant = 20
            
            stackView4.isHidden = false
            heightConstraint4.constant = 130
            topConstraint4.constant = 15
            
            constraintContentHeight.constant = 435
        default:
            return
        }
        
    }
    
    
    static func updateButtonForThreeValues(number: Int,
                                           constraintContentHeight: NSLayoutConstraint!,
                                           constraintContentHeightValue: CGFloat!,
                                           isManager: Bool,
                                           stackView: UIStackView,
                                           bottomConstraint1: NSLayoutConstraint!,
                                           heightConstraint1: NSLayoutConstraint!,
                                           buttonAdd: UIButton,
                                           buttonDelete: UIButton) {
        switch number {
        case 1:
            if(!isManager) {
                stackView.isHidden = true
                heightConstraint1.constant = 0
                bottomConstraint1.constant = 0
                constraintContentHeight.constant = constraintContentHeightValue
                buttonDelete.isEnabled = false
                buttonAdd.isEnabled = false
            } else {
                buttonDelete.isHidden = true
                buttonAdd.isHidden = false
            }
        case 2:
            if(!isManager) {
                stackView.isHidden = true
                heightConstraint1.constant = 0
                bottomConstraint1.constant = 0
                constraintContentHeight.constant = 0
                
                constraintContentHeight.constant = constraintContentHeightValue
                
                buttonDelete.isEnabled = false
                buttonAdd.isEnabled = false
            } else {
                buttonDelete.isHidden = false
                buttonAdd.isHidden = false
            }
        case 3:
            if(!isManager) {
                stackView.isHidden = true
                heightConstraint1.constant = 0
                bottomConstraint1.constant = 0
                constraintContentHeight.constant = 0
                
                constraintContentHeight.constant = constraintContentHeightValue
                
                buttonDelete.isEnabled = false
                buttonAdd.isEnabled = false
            } else {
                buttonDelete.isHidden = false
                buttonAdd.isHidden = true
            }
        default:
            return
        }
        
    }
    
    static func updateSkillButton(number: Int,
                                  buttonAdd: UIButton,
                                  buttonDelete: UIButton) {
        switch number {
        case 1:
            buttonDelete.isHidden = true
            buttonDelete.isUserInteractionEnabled = false
            buttonAdd.isHidden = false
            buttonAdd.isUserInteractionEnabled = true
            
        case 2:
            buttonDelete.isHidden = false
            buttonDelete.isUserInteractionEnabled = true
            buttonAdd.isHidden = true
            buttonAdd.isUserInteractionEnabled = false
            
        default:
            return
        }
        
    }
    
}
