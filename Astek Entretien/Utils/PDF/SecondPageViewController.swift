//
//  SecondPageViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 04/12/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase
import PDFGenerator


class SecondPageViewController: UIViewController {
    
    
    let db = Firestore.firestore()
    
    var pageController: UIViewController!

    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var titlePlan: UILabel!
    @IBOutlet weak var bilanPlanText: UILabel!
    @IBOutlet weak var targetPlanText: UILabel!
    @IBOutlet weak var evolutionPlanText: UILabel!
    @IBOutlet weak var formationPlanText: UILabel!
    
    @IBOutlet weak var firstTitleText: UILabel!
    @IBOutlet weak var bilanText: UILabel!
    
    @IBOutlet weak var secondTitleText: UILabel!
    @IBOutlet weak var appreciationEmployeeText: UILabel!
    
    @IBOutlet weak var thirdTitleText: UILabel!
    @IBOutlet weak var appreciationManagerText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageController = self
        
        PDFUtil.tabView.append(pageView)
        
        initText()
        
        firstRectangleValue()
    }
    
    private func initText() {
        PDFUtil.planUI(titlePlan: titlePlan, bilanPlanText: bilanPlanText,
        targetPlanText: targetPlanText, evolutionPlanText: evolutionPlanText,
        formationPlanText: formationPlanText)
        
        firstTitleText.underline()
        bilanText!.layer.borderWidth = 1
        
        secondTitleText.underline()
        appreciationEmployeeText!.layer.borderWidth = 1
        
        thirdTitleText.underline()
        appreciationManagerText!.layer.borderWidth = 1
        
    }
    
    private func firstRectangleValue() {
        var text: String = ""
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("bilanMission").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let bilanMission = (document.get("bilanMission") as! String)
                    
                    text = "  \(bilanMission)"
                    self.bilanText.text = text
                    
                    self.secondRectangleValue()
                }
            }
        }
    }
    
    private func secondRectangleValue() {
        var text: String = ""
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("employeeAppreciation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let gain = (document.get("gain") as! String)
                    let improvement = (document.get("improvement") as! String)
                    let weakness = (document.get("weaknesses") as! String)

                    
                    text = "  Apports : \(gain) \n \n \n"
                    text += "  Points forts : \(improvement) \n \n \n"
                    text += "  Points à améliorer : \(weakness)"
                    
                    self.appreciationEmployeeText.text = text
                    
                    self.thirdRectangleValue()
                }
            }
        }
    }
    
    private func thirdRectangleValue() {
        var text: String = ""
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("managerAppreciation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let gain = (document.get("gain") as! String)
                    let improvement = (document.get("improvement") as! String)
                    let weakness = (document.get("weaknesses") as! String)

                    
                    text = "  Apports : \(gain) \n \n \n"
                    text += "  Points forts : \(improvement) \n \n \n"
                    text += "  Points à améliorer : \(weakness)"
                    
                    self.appreciationManagerText.text = text
                    
                    self.performSegue(withIdentifier: "thirdPDF", sender: nil)
                }
            }
        }
    }
    
    
    
}

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
