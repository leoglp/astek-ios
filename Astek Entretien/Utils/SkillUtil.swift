//
//  SkillUtil.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 26/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit

class SkillUtil {
    
    /********************************** One Skill ******************************************/
    static func checkNumberValueOK(employeeGrad1: UITextField, managerGrad1: UITextField) -> Bool {
        
        var intEmployeeGrad1 : Int = 0
        if(employeeGrad1.text != "") {
            intEmployeeGrad1 = Int(employeeGrad1.text!)!
        }
        var intManagerGrad1 : Int = 0
        if(managerGrad1.text != "") {
            intManagerGrad1 = Int(managerGrad1.text!)!
        }
        
        
        if(AuthenticationUtil.isManager) {
            if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                && (intManagerGrad1 == 1 || intManagerGrad1 == 2 || intManagerGrad1 == 3 || intManagerGrad1 == 4)) {
                return true
            } else {
                return false
            }
        } else {
            if(intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4) {
                return true
            } else {
                return false
            }
        }
    }
    
    static func initText(employeeGrad1: UITextField, managerGrad1: UITextField,
                         example1: UITextField, improvement1: UITextField) {
        UIUtil.setBottomBorder(textField: employeeGrad1)
        UIUtil.setBottomBorder(textField: managerGrad1)
        UIUtil.textAlign(textField: example1)
        UIUtil.textAlign(textField: improvement1)
        
        if(!AuthenticationUtil.isManager) {
            UIUtil.textBottomBorderDisabled(textField: managerGrad1)
            UIUtil.textDisabled(textField: improvement1)
        }
    }
    
    
    
    
    
    /********************************** Two Skills ****************************************/
    static func updateSkillButtonForTwoSkills(number: Int,
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
    
    static func checkNumberValueOK(employeeGrad1: UITextField, managerGrad1: UITextField,
                                   employeeGrad2: UITextField, managerGrad2: UITextField,
                                   numberTarget: Int) -> Bool {
        
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
                    return true
                } else {
                    return false
                }
            } else {
                if(intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4) {
                    return true
                } else {
                    return false
                }
            }
        case 2:
            if(AuthenticationUtil.isManager) {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intManagerGrad1 == 1 || intManagerGrad1 == 2 || intManagerGrad1 == 3 || intManagerGrad1 == 4)
                    && (intEmployeeGrad2 == 1 || intEmployeeGrad2 == 2 || intEmployeeGrad2 == 3 || intEmployeeGrad2 == 4)
                    && (intManagerGrad2 == 1 || intManagerGrad2 == 2 || intManagerGrad2 == 3 || intManagerGrad2 == 4)) {
                    return true
                } else {
                    return false
                }
            } else {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intEmployeeGrad2 == 1 || intEmployeeGrad2 == 2 || intEmployeeGrad2 == 3 || intEmployeeGrad2 == 4)){
                    return true
                } else {
                    return false
                }
            }
        default:
            return false
        }
    }
    
    
    static func initText(skill1: UITextField, employeeGrad1: UITextField, managerGrad1: UITextField,
                         example1: UITextField, improvement1: UITextField,
                         skill2: UITextField, employeeGrad2: UITextField, managerGrad2: UITextField,
                         example2: UITextField, improvement2: UITextField) {
        UIUtil.textAlign(textField: skill1)
        UIUtil.setBottomBorder(textField: employeeGrad1)
        UIUtil.setBottomBorder(textField: managerGrad1)
        UIUtil.textAlign(textField: example1)
        UIUtil.textAlign(textField: improvement1)
        
        UIUtil.textAlign(textField: skill2)
        UIUtil.setBottomBorder(textField: employeeGrad2)
        UIUtil.setBottomBorder(textField: managerGrad2)
        UIUtil.textAlign(textField: example2)
        UIUtil.textAlign(textField: improvement2)
        
        if(!AuthenticationUtil.isManager) {
            UIUtil.textBottomBorderDisabled(textField: managerGrad1)
            UIUtil.textDisabled(textField: improvement1)
            UIUtil.textBottomBorderDisabled(textField: managerGrad2)
            UIUtil.textDisabled(textField: improvement2)
        }
    }
    
    
    /********************************** Three Skills ****************************************/
    static func checkNumberValueOK(employeeGrad1: UITextField, managerGrad1: UITextField,
                                   employeeGrad2: UITextField, managerGrad2: UITextField,
                                   employeeGrad3: UITextField, managerGrad3: UITextField,
                                   numberTarget: Int) -> Bool {
        
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
        
        var intEmployeeGrad3 : Int = 0
        if(employeeGrad3.text != "") {
            intEmployeeGrad3 = Int(employeeGrad3.text!)!
        }
        var intManagerGrad3 : Int = 0
        if(managerGrad3.text != "") {
            intManagerGrad3 = Int(managerGrad3.text!)!
        }
        
        switch numberTarget {
        case 1:
            if(AuthenticationUtil.isManager) {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intManagerGrad1 == 1 || intManagerGrad1 == 2 || intManagerGrad1 == 3 || intManagerGrad1 == 4)) {
                    return true
                } else {
                    return false
                }
            } else {
                if(intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4) {
                    return true
                } else {
                    return false
                }
            }
        case 2:
            if(AuthenticationUtil.isManager) {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intManagerGrad1 == 1 || intManagerGrad1 == 2 || intManagerGrad1 == 3 || intManagerGrad1 == 4)
                    && (intEmployeeGrad2 == 1 || intEmployeeGrad2 == 2 || intEmployeeGrad2 == 3 || intEmployeeGrad2 == 4)
                    && (intManagerGrad2 == 1 || intManagerGrad2 == 2 || intManagerGrad2 == 3 || intManagerGrad2 == 4)) {
                    return true
                } else {
                    return false
                }
            } else {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intEmployeeGrad2 == 1 || intEmployeeGrad2 == 2 || intEmployeeGrad2 == 3 || intEmployeeGrad2 == 4)){
                    return true
                } else {
                    return false
                }
            }
            
        case 3:
            if(AuthenticationUtil.isManager) {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intManagerGrad1 == 1 || intManagerGrad1 == 2 || intManagerGrad1 == 3 || intManagerGrad1 == 4)
                    && (intEmployeeGrad2 == 1 || intEmployeeGrad2 == 2 || intEmployeeGrad2 == 3 || intEmployeeGrad2 == 4)
                    && (intManagerGrad2 == 1 || intManagerGrad2 == 2 || intManagerGrad2 == 3 || intManagerGrad2 == 4)
                    && (intEmployeeGrad3 == 1 || intEmployeeGrad3 == 2 || intEmployeeGrad3 == 3 || intEmployeeGrad3 == 4)
                    && (intManagerGrad3 == 1 || intManagerGrad3 == 2 || intManagerGrad3 == 3 || intManagerGrad3 == 4)) {
                    return true
                } else {
                    return false
                }
            } else {
                if((intEmployeeGrad1 == 1 || intEmployeeGrad1 == 2 || intEmployeeGrad1 == 3 || intEmployeeGrad1 == 4)
                    && (intEmployeeGrad2 == 1 || intEmployeeGrad2 == 2 || intEmployeeGrad2 == 3 || intEmployeeGrad2 == 4)
                    && (intEmployeeGrad3 == 1 || intEmployeeGrad3 == 2 || intEmployeeGrad3 == 3 || intEmployeeGrad3 == 4)){
                    return true
                } else {
                    return false
                }
            }
        default:
            return false
        }
    }
    
    
    
    static func initText(skill1: UITextField, employeeGrad1: UITextField, managerGrad1: UITextField,
                         example1: UITextField, improvement1: UITextField,
                         skill2: UITextField, employeeGrad2: UITextField, managerGrad2: UITextField,
                         example2: UITextField, improvement2: UITextField,
                         skill3: UITextField, employeeGrad3: UITextField, managerGrad3: UITextField,
                         example3: UITextField, improvement3: UITextField) {
        
        UIUtil.textAlign(textField: skill1)
        UIUtil.setBottomBorder(textField: employeeGrad1)
        UIUtil.setBottomBorder(textField: managerGrad1)
        UIUtil.textAlign(textField: example1)
        UIUtil.textAlign(textField: improvement1)
        
        UIUtil.textAlign(textField: skill2)
        UIUtil.setBottomBorder(textField: employeeGrad2)
        UIUtil.setBottomBorder(textField: managerGrad2)
        UIUtil.textAlign(textField: example2)
        UIUtil.textAlign(textField: improvement2)
        
        UIUtil.textAlign(textField: skill3)
        UIUtil.setBottomBorder(textField: employeeGrad3)
        UIUtil.setBottomBorder(textField: managerGrad3)
        UIUtil.textAlign(textField: example3)
        UIUtil.textAlign(textField: improvement3)
        
        if(!AuthenticationUtil.isManager) {
            UIUtil.textBottomBorderDisabled(textField: managerGrad1)
            UIUtil.textDisabled(textField: improvement1)
            UIUtil.textBottomBorderDisabled(textField: managerGrad2)
            UIUtil.textDisabled(textField: improvement2)
            UIUtil.textBottomBorderDisabled(textField: managerGrad3)
            UIUtil.textDisabled(textField: improvement3)
        }
    }
    
    
    static func updateSkillButtonForThreeSkills(number: Int,
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
            buttonAdd.isHidden = false
            buttonAdd.isUserInteractionEnabled = true
            
        case 3:
            buttonDelete.isHidden = false
            buttonDelete.isUserInteractionEnabled = true
            buttonAdd.isHidden = true
            buttonAdd.isUserInteractionEnabled = false
            
        default:
            return
        }
        
    }
    
}
