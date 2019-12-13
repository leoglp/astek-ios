//
//  ThirdPageViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 04/12/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase
import PDFGenerator

class ThirdPageViewController: UIViewController {
    
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
    
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var firstRightText: UILabel!
    @IBOutlet weak var secondRightText: UILabel!
    @IBOutlet weak var thirdRightText: UILabel!
    
    @IBOutlet weak var appreciationTitle: UILabel!
    @IBOutlet weak var answerATitle: UILabel!
    @IBOutlet weak var answerBTitle: UILabel!
    @IBOutlet weak var answerCTitle: UILabel!
    @IBOutlet weak var answerDTitle: UILabel!
    @IBOutlet weak var answerA: UILabel!
    @IBOutlet weak var answerB: UILabel!
    @IBOutlet weak var answerC: UILabel!
    @IBOutlet weak var answerD: UILabel!
    
    @IBOutlet weak var commentaryTitle: UILabel!
    @IBOutlet weak var commentaryText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = self
        
        PDFUtil.tabView.append(pageView)
        
        initText()
        
        retrieveFirstValue()
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
        
        resultTitle!.layer.borderWidth = 1
        firstRightText!.layer.borderWidth = 1
        secondRightText!.layer.borderWidth = 1
        thirdRightText!.layer.borderWidth = 1
        
        appreciationTitle!.layer.borderWidth = 1
        answerA!.layer.borderWidth = 1
        answerATitle!.layer.borderWidth = 1
        answerB!.layer.borderWidth = 1
        answerBTitle!.layer.borderWidth = 1
        answerC!.layer.borderWidth = 1
        answerCTitle!.layer.borderWidth = 1
        answerD!.layer.borderWidth = 1
        answerDTitle!.layer.borderWidth = 1
        
        commentaryTitle.underline()
        commentaryText!.layer.borderWidth = 1
    }
    
    
    private func retrieveFirstValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("targetEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.isEmpty) {
                    self.retrieveSecondValue()
                } else {
                    for document in querySnapshot!.documents {
                        var text = ""
                        if (document.get("target1") != nil) {
                            let target1 = (document.get("target1") as! String)
                            text = "  1 - \(target1)"
                            self.firstLeftText.text = text
                        } else {
                            self.firstLeftText.text = "  /"
                        }
                        
                        if (document.get("target2") != nil) {
                            let target2 = (document.get("target2") as! String)
                            text = "  2 - \(target2)"
                            self.secondLeftText.text = text
                        } else {
                            self.secondLeftText.text = "  /"
                        }
                        
                        if (document.get("target3") != nil) {
                            let target3 = (document.get("target3") as! String)
                            text = "  3 - \(target3)"
                            self.thirdLeftText.text = text
                        } else {
                            self.thirdLeftText.text = "  /"
                        }
                        
                        
                        if (document.get("result1") != nil) {
                            let result1 = (document.get("result1") as! String)
                            text = "  1 - \(result1)"
                            self.firstRightText.text = text
                        } else {
                            self.firstRightText.text = "  /"
                        }
                        
                        if (document.get("result2") != nil) {
                            let result2 = (document.get("result2") as! String)
                            text = "  2 - \(result2)"
                            self.secondRightText.text = text
                        } else {
                            self.secondRightText.text = "  /"
                        }
                        
                        if (document.get("result3") != nil) {
                            let result3 = (document.get("result3") as! String)
                            text = "  3 - \(result3)"
                            self.thirdRightText.text = text
                        } else {
                            self.thirdRightText.text = "  /"
                        }
                        
                        self.retrieveSecondValue()
                        
                    }
                }
                
                
                
            }
        }
    }
    
    
    private func retrieveSecondValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("performanceEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.isEmpty) {
                    self.performSegue(withIdentifier: "fourthPDF", sender: nil)
                } else {
                    for document in querySnapshot!.documents {
                        if(document.get("performanceEvaluation") != nil) {
                            let performance = (document.get("performanceEvaluation") as! String)
                            
                            switch performance {
                            case "Très Satisfaisant":
                                self.answerA.backgroundColor = UIColor.darkGray
                            case "Satisfaisant":
                                self.answerB.backgroundColor = UIColor.darkGray
                            case "Moyen":
                                self.answerC.backgroundColor = UIColor.darkGray
                            case "Insuffisant":
                                self.answerD.backgroundColor = UIColor.darkGray
                            default:
                                return
                            }
                            
                        }
                        
                        if (document.get("commentary") != nil) {
                            self.commentaryText.text = "  " + (document.get("commentary") as! String)
                        } else {
                            self.commentaryText.text = "  /"
                        }
                        
                        self.performSegue(withIdentifier: "fourthPDF", sender: nil)
                    }
                }
                
            }
        }
    }
    
    
}

