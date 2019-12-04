//
//  PDFUtil.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 29/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import PDFGenerator
import MessageUI

class PDFUtil: NSObject {
        
    static var tabView : Array<UIView> = []
 
    static func planUI(titlePlan: UILabel!, bilanPlanText: UILabel!,
                       targetPlanText: UILabel!, evolutionPlanText: UILabel!,
                       formationPlanText: UILabel!) {
        titlePlan!.layer.borderWidth = 1
        bilanPlanText!.layer.borderWidth = 1
        targetPlanText!.layer.borderWidth = 1
        evolutionPlanText!.layer.borderWidth = 1
        formationPlanText!.layer.borderWidth = 1
    }
}
