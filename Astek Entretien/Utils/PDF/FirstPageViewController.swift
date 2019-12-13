//
//  FirstPageViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 29/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import PDFGenerator
import Firebase


class FirstPageViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var pageController: UIViewController!
    
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var titleFirstRectangle: UILabel!
    @IBOutlet weak var firstLeftRectangleText: UILabel!
    @IBOutlet weak var firstRightRectangleText: UILabel!
    
    @IBOutlet weak var titleSecondRectangle: UILabel!
    @IBOutlet weak var secondLeftRectangleText: UILabel!
    @IBOutlet weak var secondRightRectangleText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageController = self
        
        PDFUtil.tabView.append(pageView)
        
        titleFirstRectangle!.layer.borderWidth = 1
        firstLeftRectangleText!.layer.borderWidth = 1
        firstRightRectangleText!.layer.borderWidth = 1
        titleSecondRectangle!.layer.borderWidth = 1
        secondLeftRectangleText!.layer.borderWidth = 1
        secondRightRectangleText!.layer.borderWidth = 1
        
        leftRectangleValue()
    }
    
    private func leftRectangleValue() {
        
        let docRef = db.collection("users").document(AuthenticationUtil.employeeDocumentId)
        
        var text: String = ""
        
        docRef.getDocument { (document, err) in
            if let document = document, document.exists {
                let name = document.get("name") as! String
                let surname = document.get("surname") as! String
                let society = document.get("society") as! String
                let birthDate = document.get("birthdate") as! String
                
                let enterDate = document.get("enterDate") as! String
                let experimentDate = document.get("experimentDate") as! String
                let function = document.get("function") as! String
                let diplom = document.get("diplom") as! String
                let obtentionDate = document.get("obtentionDate") as! String
                
                
                text = "  NOM Prénom : \(name) \(surname)  \n \n"
                text += "  Société : \(society)  \n \n"
                text += "  Date de naissance : \(birthDate)  \n \n"
                text += "  Date d'entrée chez Astek : \(enterDate)  \n \n"
                text += "  Nbre d’Années d’expérience total : \(experimentDate)  \n \n"
                text += "  Fonction : \(function)  \n \n"
                text += "  Diplôme / Ecole : \(diplom)  \n \n"
                text += "  Date d'obtention : \(obtentionDate)"
                
                self.firstLeftRectangleText.text = text
                
                self.rightRectangleValue()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    private func rightRectangleValue() {
        var text: String = ""
        
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("interviewContext").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if(querySnapshot!.isEmpty) {
                    self.secondRectangleValue()
                } else {
                    for document in querySnapshot!.documents {
                        
                        var bilanDate = ""
                        if(document.get("bilanDate") != nil) {
                            bilanDate = (document.get("bilanDate") as! String)
                        }
                        var previousDate = ""
                        if(document.get("previousDate") != nil) {
                            previousDate = (document.get("previousDate") as! String)
                        }
                        
                        var interviewDate = ""
                        if(document.get("interviewDate") != nil) {
                            interviewDate = (document.get("interviewDate") as! String)
                        }
                        
                        var managerName = ""
                        if(document.get("managerName") != nil) {
                            managerName = (document.get("managerName") as! String)
                        }
                        
                        
                        
                        
                        text = "  Année du bilan : \(bilanDate) \n \n"
                        text += "  Date de l’entretien N-1 : \(previousDate) \n \n"
                        text += "  Date de l’entretien N : \(interviewDate)  \n \n"
                        text += "  Manager : \(managerName) \n \n"
                        
                        self.firstRightRectangleText.text = text
                        
                        self.secondRectangleValue()
                    }
                }
                
            }
        }
    }
    
    private func secondRectangleValue() {
        let leftInfo = "  Evaluation de la Performance / \n  Compétences : \n" +
            "    1 - Très Satisfaisant \n" +
            "    2 - Satisfaisant \n" +
            "    3 - Moyen \n" +
        "    4 - Insuffisant"
        
        self.secondLeftRectangleText.text = leftInfo
        
        let rightnfo = "  Evaluation de maitrise des \n  compétences : \n" +
            "    A - Expertise \n" +
            "    B - Capacité à mettre en oeuvre de \n    manière autonome \n" +
            "    C - Capacité à mettre en oeuvre \n    partiellement \n" +
        "    D - Notion"
        
        self.secondRightRectangleText.text = rightnfo
        
        performSegue(withIdentifier: "secondPDF", sender: nil)
    }
}


