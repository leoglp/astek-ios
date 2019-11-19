//
//  UIUtil.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 15/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

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
}
