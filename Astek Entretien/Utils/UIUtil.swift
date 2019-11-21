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
            controller.performSegue(withIdentifier: "showBilanMission", sender: nil)
        default:
            return
        }
    }
    
    static func getCurrentPage(className: String) -> Int {
        print("TITI getCurrentPage : \(ArrayValues.classValues.firstIndex(of: className)!)")

        return ArrayValues.classValues.firstIndex(of: className)! + 1
    }
    
    static func getTotalPage() -> Int {
        return ArrayValues.classValues.capacity
    }
    
    static func goToNextPage(className: String, controller: UIViewController){
        let index = ArrayValues.classValues.firstIndex(of: className)! + 2
        print("TITI goToNextPage : \(index)")

        goToPage(pageNumber: index, controller: controller)
    }
    
    static func goToPreviousPage(className: String, controller: UIViewController){
        let index = ArrayValues.classValues.firstIndex(of: className)!
        print("TITI goToPreviousPage : \(index)")

        goToPage(pageNumber: index, controller: controller)
    }
    
    static func backToHome(controller: UIViewController) {
        try! Auth.auth().signOut()
        controller.performSegue(withIdentifier: "showFirstPage", sender: nil)
    }
    
}
