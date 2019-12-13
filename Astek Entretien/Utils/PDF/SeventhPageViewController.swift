//
//  SeventhPageViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 06/12/2019.
//  Copyright © 2019 Astek. All rights reserved.
//


import UIKit
import Firebase
import PDFGenerator

class SeventhPageViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var pageController: UIViewController!
    
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var titlePlan: UILabel!
    @IBOutlet weak var bilanPlanText: UILabel!
    @IBOutlet weak var targetPlanText: UILabel!
    @IBOutlet weak var evolutionPlanText: UILabel!
    @IBOutlet weak var formationPlanText: UILabel!
    
    @IBOutlet weak var firstTitleText: UILabel!
    
    @IBOutlet weak var formationTitle: UILabel!
    @IBOutlet weak var firstLeftText: UILabel!
    @IBOutlet weak var secondLeftText: UILabel!
    
    @IBOutlet weak var implementationTitle: UILabel!
    @IBOutlet weak var firstMiddleText: UILabel!
    @IBOutlet weak var secondMiddleText: UILabel!
    
    @IBOutlet weak var commentaryTitle: UILabel!
    @IBOutlet weak var firstRightText: UILabel!
    @IBOutlet weak var secondRightText: UILabel!
    
    
    @IBOutlet weak var secondTitleText1: UILabel!
    @IBOutlet weak var secondTitleText2: UILabel!
    
    
    @IBOutlet weak var wishTitle: UILabel!
    @IBOutlet weak var wishText1: UILabel!
    @IBOutlet weak var wishText2: UILabel!
    
    @IBOutlet weak var motivationTitle: UILabel!
    @IBOutlet weak var motivationText1: UILabel!
    @IBOutlet weak var motivationText2: UILabel!
    
    @IBOutlet weak var modalityTitle: UILabel!
    @IBOutlet weak var modalityText1: UILabel!
    @IBOutlet weak var modalityText2: UILabel!
    
    @IBOutlet weak var cpfTitle: UILabel!
    @IBOutlet weak var cpfNumber: UILabel!
    @IBOutlet weak var cpfDate: UILabel!
    @IBOutlet weak var cpfQuestion: UILabel!
    
    @IBOutlet weak var managerCommentaryTitle: UILabel!
    @IBOutlet weak var managerCommentary: UILabel!
    
    
    
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
        formationTitle!.layer.borderWidth = 1
        firstLeftText!.layer.borderWidth = 1
        secondLeftText!.layer.borderWidth = 1
        
        implementationTitle!.layer.borderWidth = 1
        firstMiddleText!.layer.borderWidth = 1
        secondMiddleText!.layer.borderWidth = 1
        
        commentaryTitle!.layer.borderWidth = 1
        firstRightText!.layer.borderWidth = 1
        secondRightText!.layer.borderWidth = 1
        
        secondTitleText1.underline()
        secondTitleText2.underline()
        
        wishTitle!.layer.borderWidth = 1
        motivationTitle!.layer.borderWidth = 1
        modalityTitle!.layer.borderWidth = 1
        
        wishText1!.layer.borderWidth = 1
        wishText2!.layer.borderWidth = 1
        
        motivationText1!.layer.borderWidth = 1
        motivationText2!.layer.borderWidth = 1
        
        modalityText1!.layer.borderWidth = 1
        modalityText2!.layer.borderWidth = 1
        
        cpfTitle.underline()
        
        managerCommentaryTitle.underline()
        managerCommentary!.layer.borderWidth = 1
    }
    
    
    private func retrieveFirstValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("bilanFormation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.isEmpty) {
                    self.retrieveSecondValue()
                } else {
                    for document in querySnapshot!.documents {
                        let entitledText = "  Intitulé : "
                        let dateText = "  Date : "
                        let durationText = "  Durée : "
                        let initiativeText = "  Initiative : "
                        
                        var entitled1 = ""
                        var date1 = ""
                        var duration1 = ""
                        var initiative1 = ""
                        
                        if(document.get("entitled1") != nil) {
                            entitled1 = (document.get("entitled1") as! String)
                        }
                        if(document.get("entitled1") != nil) {
                            date1 = (document.get("date1") as! String)
                        }
                        if(document.get("entitled1") != nil) {
                            duration1 = (document.get("duration1") as! String)
                        }
                        if(document.get("entitled1") != nil) {
                            initiative1 = (document.get("initiative1") as! String)
                        }
                        
                        var text = entitledText + entitled1 + "\n \n" +
                            dateText + date1 + "\n" +
                            durationText + duration1 + "\n" +
                            initiativeText + initiative1
                        
                        self.firstLeftText.text = text
                        
                        var implementation1 = ""
                        var commentary1 = ""
                        if(document.get("implementation1") != nil) {
                            implementation1 = "  " + (document.get("implementation1") as! String)
                        }
                        if(document.get("commentary1") != nil) {
                            commentary1 = "  " + (document.get("commentary1") as! String)
                        }
                        self.firstMiddleText.text = implementation1
                        self.firstRightText.text = commentary1
                        
                        
                        var entitled2 = ""
                        var date2 = ""
                        var duration2 = ""
                        var initiative2 = ""
                        var implementation2 = ""
                        var commentary2 = ""
                        
                        if (document.get("entitled2") != nil || (document.get("entitled2") as! String) == "") {
                            entitled2 = (document.get("entitled2") as! String)
                            date2 = (document.get("date2") as! String)
                            duration2 = (document.get("duration2") as! String)
                            initiative2 = (document.get("initiative2") as! String)
                            implementation2 = "  " + (document.get("implementation2") as! String)
                            commentary2 = "  " + (document.get("commentary2") as! String)
                        } else {
                            entitled2 = "/ "
                            date2 = "/ "
                            duration2 = "/ "
                            initiative2 = "/ "
                            implementation2 = "  / "
                            commentary2 = "  / "
                        }
                        
                        text = entitledText + entitled2 + "\n \n" +
                            dateText + date2 + "\n" +
                            durationText + duration2 + "\n" +
                            initiativeText + initiative2
                        
                        self.secondLeftText.text = text
                        self.secondMiddleText.text = implementation2
                        self.secondRightText.text = commentary2
                        
                        self.retrieveSecondValue()
                    }
                }
                
                
                
                
            }
        }
    }
    
    
    private func retrieveSecondValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("wishFormation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.isEmpty) {
                    self.retrieveCPFValue()
                } else {
                    for document in querySnapshot!.documents {
                        var target1 = ""
                        var wish1 = ""
                        var motivation1 = ""
                        var modality1 = ""
                        
                        if(document.get("target1") != nil) {
                            target1 = " " + (document.get("target1") as! String)
                        }
                        if(document.get("wish1") != nil) {
                            wish1 = " " + (document.get("wish1") as! String)
                        }
                        if(document.get("motivation1") != nil) {
                            motivation1 = " " + (document.get("motivation1") as! String)
                        }
                        if(document.get("modality1") != nil) {
                            modality1 = " " + (document.get("modality1") as! String)
                        }
                        
                        var text = wish1 + "\n \n" + target1
                        self.wishText1.text = text
                        
                        self.motivationText1.text = motivation1
                        self.modalityText1.text = modality1
                        
                        var target2 = ""
                        var wish2 = ""
                        var motivation2 = ""
                        var modality2 = ""
                        
                        if (document.get("target2") != nil) {
                            target2 = (document.get("target2") as! String)
                            wish2 = (document.get("wish2") as! String)
                            motivation2 = (document.get("motivation2") as! String)
                            modality2 = (document.get("modality2") as! String)
                        } else {
                            target2 = "  / "
                            wish2 = "  / "
                            motivation2 = "  / "
                            modality2 = "  / "
                        }
                        
                        text = wish2 + "\n \n" + target2
                        self.wishText2.text = text
                        
                        self.motivationText2.text = motivation2
                        self.modalityText2.text = modality2
                        
                        self.retrieveCPFValue()
                    }
                }
                
                
            }
        }
    }
    
    private func retrieveCPFValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("cpf").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if(querySnapshot!.isEmpty) {
                    self.performSegue(withIdentifier: "heighthPDF", sender: nil)
                } else {
                    for document in querySnapshot!.documents {
                        
                        var numberHours = ""
                        if(document.get("numberHours") != nil) {
                            numberHours = (document.get("numberHours") as! String)
                        }
                        self.cpfNumber.text = numberHours
                        
                        var date = ""
                        if(document.get("date") != nil) {
                            date = (document.get("date") as! String)
                        }
                        self.cpfDate.text = date
                        
                        var question = ""
                        if(document.get("question") != nil) {
                            question = (document.get("question") as! String)
                        }
                        self.cpfQuestion.text = question
                        
                        var commentary = ""
                        if(document.get("commentary") != nil) {
                            commentary = " " + (document.get("commentary") as! String)
                        }
                        self.managerCommentary.text = commentary
                        
                        self.performSegue(withIdentifier: "heighthPDF", sender: nil)
                    }
                }
            }
        }
    }
    
    
}





