//
//  SixthPageViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 05/12/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase
import PDFGenerator

class SixthPageViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var pageController: UIViewController!
    
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var titlePlan: UILabel!
    @IBOutlet weak var bilanPlanText: UILabel!
    @IBOutlet weak var targetPlanText: UILabel!
    @IBOutlet weak var evolutionPlanText: UILabel!
    @IBOutlet weak var formationPlanText: UILabel!
    
    @IBOutlet weak var firstTitleText: UILabel!
    
    @IBOutlet weak var targetTitle: UILabel!
    @IBOutlet weak var firstLeftText: UILabel!
    @IBOutlet weak var secondLeftText: UILabel!
    @IBOutlet weak var thirdLeftText: UILabel!
    
    @IBOutlet weak var motivationTitle: UILabel!
    @IBOutlet weak var firstMiddleText: UILabel!
    @IBOutlet weak var secondMiddleText: UILabel!
    @IBOutlet weak var thirdMiddleText: UILabel!
    
    @IBOutlet weak var meansTitle: UILabel!
    @IBOutlet weak var firstRightText: UILabel!
    @IBOutlet weak var secondRightText: UILabel!
    @IBOutlet weak var thirdRightText: UILabel!
    
    @IBOutlet weak var mobility: UILabel!
    @IBOutlet weak var activity: UILabel!
    @IBOutlet weak var othersWishes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = self
        
        PDFUtil.tabView.append(pageView)
        
        initText()
        
        retrieveShortValue()
    }
    
    
    private func initText() {
        
        PDFUtil.planUI(titlePlan: titlePlan, bilanPlanText: bilanPlanText,
                       targetPlanText: targetPlanText, evolutionPlanText: evolutionPlanText,
                       formationPlanText: formationPlanText)
        
        firstTitleText.underline()
        targetTitle!.layer.borderWidth = 1
        firstLeftText!.layer.borderWidth = 1
        secondLeftText!.layer.borderWidth = 1
        thirdLeftText!.layer.borderWidth = 1
        
        motivationTitle!.layer.borderWidth = 1
        firstMiddleText!.layer.borderWidth = 1
        secondMiddleText!.layer.borderWidth = 1
        thirdMiddleText!.layer.borderWidth = 1
        
        meansTitle!.layer.borderWidth = 1
        firstRightText!.layer.borderWidth = 1
        secondRightText!.layer.borderWidth = 1
        thirdRightText!.layer.borderWidth = 1
        
    }
    
    private func retrieveShortValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("shortEvolution").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if(querySnapshot!.isEmpty) {
                    self.retrieveMediumValue()
                } else {
                    for document in querySnapshot!.documents {
                        var evolution = ""
                        if(document.get("evolution") != nil){
                            evolution = (document.get("evolution") as! String)
                        }
                        let text = "  A court termes : \(evolution)"
                        self.firstLeftText.text = text
                        
                        var justification = ""
                        if(document.get("justification") != nil){
                            justification = (document.get("justification") as! String)
                        }
                        self.firstMiddleText.text = "  " + justification
                        
                        var means = ""
                        if(document.get("means") != nil){
                            means = (document.get("means") as! String)
                        }
                        self.firstRightText.text = "  " + means
                        
                        self.retrieveMediumValue()
                    }
                }
            }
        }
    }
    
    private func retrieveMediumValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("mediumEvolution").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.isEmpty) {
                    self.retrieveLongValue()
                } else {
                    for document in querySnapshot!.documents {
                        var evolution = ""
                        if(document.get("evolution") != nil){
                            evolution = (document.get("evolution") as! String)
                        }
                        let text = "  A moyen termes : \(evolution)"
                        self.secondLeftText.text = text
                        
                        var justification = ""
                        if(document.get("justification") != nil){
                            justification = (document.get("justification") as! String)
                        }
                        self.secondMiddleText.text = "  " + justification
                        
                        var means = ""
                        if(document.get("means") != nil){
                            means = (document.get("means") as! String)
                        }
                        self.secondRightText.text = "  " + means
                        
                        self.retrieveLongValue()
                        
                    }
                }
            }
        }
    }
    
    private func retrieveLongValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("longEvolution").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if(querySnapshot!.isEmpty) {
                    self.retrieveOthersValue()
                } else {
                    for document in querySnapshot!.documents {
                        var evolution = ""
                        if(document.get("evolution") != nil){
                            evolution = (document.get("evolution") as! String)
                        }
                        let text = "  A long termes : \(evolution)"
                        self.thirdLeftText.text = text
                        
                        var justification = ""
                        if(document.get("justification") != nil){
                            justification = (document.get("justification") as! String)
                        }
                        self.thirdMiddleText.text = "  " + justification
                        
                        var means = ""
                        if(document.get("means") != nil){
                            means = (document.get("means") as! String)
                        }
                        self.thirdRightText.text = "  " + means
                        
                        self.retrieveOthersValue()
                    }
                }
            }
        }
    }
    
    
    private func retrieveOthersValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("othersEvolution").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.isEmpty) {
                    self.performSegue(withIdentifier: "seventhPDF", sender: nil)
                } else {
                    for document in querySnapshot!.documents {
                        if (document.get("mobility") != nil) {
                            let mobility = (document.get("mobility") as! String)
                            self.mobility.text = mobility
                        } else {
                            self.mobility.text = "/ "
                        }
                        
                        if (document.get("othersEvolution") != nil) {
                            let othersEvolution = (document.get("othersEvolution") as! String)
                            self.activity.text = othersEvolution
                        } else {
                            self.activity.text = "/ "
                        }
                        
                        if (document.get("others") != nil) {
                            let others = (document.get("others") as! String)
                            self.othersWishes.text = others
                        } else {
                            self.othersWishes.text = "/ "
                        }
                        
                        self.performSegue(withIdentifier: "seventhPDF", sender: nil)
                        
                    }
                }
            }
        }
    }
    
}



