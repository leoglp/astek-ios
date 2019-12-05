//
//  FourthPageViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 04/12/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase
import PDFGenerator

class FourthPageViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var pageController: UIViewController!
    
    @IBOutlet weak var pageView: UIView!
    
    //Plan
    @IBOutlet weak var titlePlan: UILabel!
    @IBOutlet weak var bilanPlanText: UILabel!
    @IBOutlet weak var targetPlanText: UILabel!
    @IBOutlet weak var evolutionPlanText: UILabel!
    @IBOutlet weak var formationPlanText: UILabel!
    
    @IBOutlet weak var firstTitleText: UILabel!
    
    @IBOutlet weak var skillTitle: UILabel!
    @IBOutlet weak var employeeGraduationTitle: UILabel!
    @IBOutlet weak var managerGraduationTitle: UILabel!
    @IBOutlet weak var exampleTitle: UILabel!
    
    //Technical
    @IBOutlet weak var technicalTitle: UILabel!
    @IBOutlet weak var technical1: UILabel!
    @IBOutlet weak var technicalEmployee1: UILabel!
    @IBOutlet weak var technicalManager1: UILabel!
    @IBOutlet weak var technicalExample1: UILabel!
    @IBOutlet weak var technical2: UILabel!
    @IBOutlet weak var technicalEmployee2: UILabel!
    @IBOutlet weak var technicalManager2: UILabel!
    @IBOutlet weak var technicalExample2: UILabel!
    
    //Profession
    @IBOutlet weak var professionTitle: UILabel!
    @IBOutlet weak var profession1: UILabel!
    @IBOutlet weak var professionEmployee1: UILabel!
    @IBOutlet weak var professionManager1: UILabel!
    @IBOutlet weak var professionExample1: UILabel!
    @IBOutlet weak var profession2: UILabel!
    @IBOutlet weak var professionEmployee2: UILabel!
    @IBOutlet weak var professionManager2: UILabel!
    @IBOutlet weak var professionExample2: UILabel!
    @IBOutlet weak var profession3: UILabel!
    @IBOutlet weak var professionEmployee3: UILabel!
    @IBOutlet weak var professionManager3: UILabel!
    @IBOutlet weak var professionExample3: UILabel!
    
    
    //Functional
    @IBOutlet weak var functionnalTitle: UILabel!
    @IBOutlet weak var functionnal1: UILabel!
    @IBOutlet weak var functionnalEmployee1: UILabel!
    @IBOutlet weak var functionnalManager1: UILabel!
    @IBOutlet weak var functionnalExample1: UILabel!
    @IBOutlet weak var functionnal2: UILabel!
    @IBOutlet weak var functionnalEmployee2: UILabel!
    @IBOutlet weak var functionnalManager2: UILabel!
    @IBOutlet weak var functionnalExample2: UILabel!
    
    //Managerial
    @IBOutlet weak var managerialTitle: UILabel!
    @IBOutlet weak var managerial1: UILabel!
    @IBOutlet weak var managerialEmployee1: UILabel!
    @IBOutlet weak var managerialManager1: UILabel!
    @IBOutlet weak var managerialExample1: UILabel!
    @IBOutlet weak var managerial2: UILabel!
    @IBOutlet weak var managerialEmployee2: UILabel!
    @IBOutlet weak var managerialManager2: UILabel!
    @IBOutlet weak var managerialExample2: UILabel!
    
    //Behavioral
    @IBOutlet weak var behavioralTitle: UILabel!
    
    //Autonomous
    @IBOutlet weak var autonomous: UILabel!
    @IBOutlet weak var autonomousEmployee: UILabel!
    @IBOutlet weak var autonomousManager: UILabel!
    @IBOutlet weak var autonomousExample: UILabel!
    
    //Adaptability
    @IBOutlet weak var adaptability: UILabel!
    @IBOutlet weak var adaptabilityEmployee: UILabel!
    @IBOutlet weak var adaptabilityManager: UILabel!
    @IBOutlet weak var adaptabilityExample: UILabel!
    
    //Team Work
    @IBOutlet weak var teamWork: UILabel!
    @IBOutlet weak var teamWorkEmployee: UILabel!
    @IBOutlet weak var teamWorkManager: UILabel!
    @IBOutlet weak var teamWorkExample: UILabel!
    
    //Creativity
    @IBOutlet weak var creativity: UILabel!
    @IBOutlet weak var creativityEmployee: UILabel!
    @IBOutlet weak var creativityManager: UILabel!
    @IBOutlet weak var creativityExample: UILabel!
    
    //Communication
    @IBOutlet weak var communication: UILabel!
    @IBOutlet weak var communicationEmployee: UILabel!
    @IBOutlet weak var communicationManager: UILabel!
    @IBOutlet weak var communicationExample: UILabel!
    
    //Implication
    @IBOutlet weak var implication: UILabel!
    @IBOutlet weak var implicationEmployee: UILabel!
    @IBOutlet weak var implicationManager: UILabel!
    @IBOutlet weak var implicationExample: UILabel!
    
    //Respect
    @IBOutlet weak var respect: UILabel!
    @IBOutlet weak var respectEmployee: UILabel!
    @IBOutlet weak var respectManager: UILabel!
    @IBOutlet weak var respectExample: UILabel!
    
    //Rigour
    @IBOutlet weak var rigour: UILabel!
    @IBOutlet weak var rigourEmployee: UILabel!
    @IBOutlet weak var rigourManager: UILabel!
    @IBOutlet weak var rigourExample: UILabel!
    
    
    //Linguistic
    @IBOutlet weak var linguisticTitle: UILabel!
    
    //English
    @IBOutlet weak var english: UILabel!
    @IBOutlet weak var englishEmployee: UILabel!
    @IBOutlet weak var englishManager: UILabel!
    @IBOutlet weak var englishExample: UILabel!
    
    //Other Language
    @IBOutlet weak var otherLanguage: UILabel!
    @IBOutlet weak var otherLanguageEmployee: UILabel!
    @IBOutlet weak var otherLanguageManager: UILabel!
    @IBOutlet weak var otherLanguageExample: UILabel!
    
    
    //Skill Evaluation
    @IBOutlet weak var evaluationTitle: UILabel!
    @IBOutlet weak var answerATitle: UILabel!
    @IBOutlet weak var answerBTitle: UILabel!
    @IBOutlet weak var answerCTitle: UILabel!
    @IBOutlet weak var answerDTitle: UILabel!
    @IBOutlet weak var answerA: UILabel!
    @IBOutlet weak var answerB: UILabel!
    @IBOutlet weak var answerC: UILabel!
    @IBOutlet weak var answerD: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = self
        
        PDFUtil.tabView.append(pageView)
        
        initText()
    }
    
    private func initText() {
        
        PDFUtil.planUI(titlePlan: titlePlan, bilanPlanText: bilanPlanText,
                       targetPlanText: targetPlanText, evolutionPlanText: evolutionPlanText,
                       formationPlanText: formationPlanText)
        
        firstTitleText.underline()
        
        skillTitle!.layer.borderWidth = 1
        skillTitle.underline()
        employeeGraduationTitle!.layer.borderWidth = 1
        employeeGraduationTitle.underline()
        employeeGraduationTitle.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        managerGraduationTitle!.layer.borderWidth = 1
        managerGraduationTitle.underline()
        managerGraduationTitle.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        exampleTitle!.layer.borderWidth = 1
        exampleTitle.underline()
        
        
        //Technical
        technicalTitle!.layer.borderWidth = 1
        technical1!.layer.borderWidth = 1
        technicalEmployee1!.layer.borderWidth = 1
        technicalManager1!.layer.borderWidth = 1
        technicalExample1!.layer.borderWidth = 1
        technical2!.layer.borderWidth = 1
        technicalEmployee2!.layer.borderWidth = 1
        technicalManager2!.layer.borderWidth = 1
        technicalExample2!.layer.borderWidth = 1
        
        //Profession
        professionTitle!.layer.borderWidth = 1
        profession1!.layer.borderWidth = 1
        professionEmployee1!.layer.borderWidth = 1
        professionManager1!.layer.borderWidth = 1
        professionExample1!.layer.borderWidth = 1
        profession2!.layer.borderWidth = 1
        professionEmployee2!.layer.borderWidth = 1
        professionManager2!.layer.borderWidth = 1
        professionExample2!.layer.borderWidth = 1
        profession3!.layer.borderWidth = 1
        professionEmployee3!.layer.borderWidth = 1
        professionManager3!.layer.borderWidth = 1
        professionExample3!.layer.borderWidth = 1
        
        //Functionnal
        functionnalTitle!.layer.borderWidth = 1
        functionnal1!.layer.borderWidth = 1
        functionnalEmployee1!.layer.borderWidth = 1
        functionnalManager1!.layer.borderWidth = 1
        functionnalExample1!.layer.borderWidth = 1
        functionnal2!.layer.borderWidth = 1
        functionnalEmployee2!.layer.borderWidth = 1
        functionnalManager2!.layer.borderWidth = 1
        functionnalExample2!.layer.borderWidth = 1
        
        //Managerial
        managerialTitle!.layer.borderWidth = 1
        managerial1!.layer.borderWidth = 1
        managerialEmployee1!.layer.borderWidth = 1
        managerialManager1!.layer.borderWidth = 1
        managerialExample1!.layer.borderWidth = 1
        managerial2!.layer.borderWidth = 1
        managerialEmployee2!.layer.borderWidth = 1
        managerialManager2!.layer.borderWidth = 1
        managerialExample2!.layer.borderWidth = 1
        
        //Behavioral
        behavioralTitle!.layer.borderWidth = 1
        
        autonomous!.layer.borderWidth = 1
        autonomousEmployee!.layer.borderWidth = 1
        autonomousManager!.layer.borderWidth = 1
        autonomousExample!.layer.borderWidth = 1
        
        adaptability!.layer.borderWidth = 1
        adaptabilityEmployee!.layer.borderWidth = 1
        adaptabilityManager!.layer.borderWidth = 1
        adaptabilityExample!.layer.borderWidth = 1
        
        teamWork!.layer.borderWidth = 1
        teamWorkEmployee!.layer.borderWidth = 1
        teamWorkManager!.layer.borderWidth = 1
        teamWorkExample!.layer.borderWidth = 1
        
        creativity!.layer.borderWidth = 1
        creativityEmployee!.layer.borderWidth = 1
        creativityManager!.layer.borderWidth = 1
        creativityExample!.layer.borderWidth = 1
        
        communication!.layer.borderWidth = 1
        communicationEmployee!.layer.borderWidth = 1
        communicationManager!.layer.borderWidth = 1
        communicationExample!.layer.borderWidth = 1
        
        implication!.layer.borderWidth = 1
        implicationEmployee!.layer.borderWidth = 1
        implicationManager!.layer.borderWidth = 1
        implicationExample!.layer.borderWidth = 1
        
        respect!.layer.borderWidth = 1
        respectEmployee!.layer.borderWidth = 1
        respectManager!.layer.borderWidth = 1
        respectExample!.layer.borderWidth = 1
        
        rigour!.layer.borderWidth = 1
        rigourEmployee!.layer.borderWidth = 1
        rigourManager!.layer.borderWidth = 1
        rigourExample!.layer.borderWidth = 1
        
        
        //Linguistic
        linguisticTitle!.layer.borderWidth = 1
        
        english!.layer.borderWidth = 1
        englishEmployee!.layer.borderWidth = 1
        englishManager!.layer.borderWidth = 1
        englishExample!.layer.borderWidth = 1
        
        otherLanguage!.layer.borderWidth = 1
        otherLanguageEmployee!.layer.borderWidth = 1
        otherLanguageManager!.layer.borderWidth = 1
        otherLanguageExample!.layer.borderWidth = 1
        
        
        evaluationTitle!.layer.borderWidth = 1
        answerA!.layer.borderWidth = 1
        answerATitle!.layer.borderWidth = 1
        answerB!.layer.borderWidth = 1
        answerBTitle!.layer.borderWidth = 1
        answerC!.layer.borderWidth = 1
        answerCTitle!.layer.borderWidth = 1
        answerD!.layer.borderWidth = 1
        answerDTitle!.layer.borderWidth = 1
        
        
        retrieveTechnicalValue()
    }
    
    
    private func retrieveTechnicalValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("technicalSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let skill = (document.get("skill1") as! String)
                    self.technical1.text = skill
                    if (document.get("skill2") != nil) {
                        let skill = (document.get("skill2") as! String)
                        self.technical2.text = skill
                    } else {
                        self.technical2.text = " / "
                    }
                    
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.technicalEmployee1.text = employeeGraduation1
                    if (document.get("employeeGraduation2") != nil) {
                        let skill = (document.get("employeeGraduation2") as! String)
                        self.technicalEmployee2.text = skill
                    } else {
                        self.technicalEmployee2.text = " / "
                    }
                    
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.technicalManager1.text = managerGraduation1
                    if (document.get("managerGraduation2") != nil) {
                        let skill = (document.get("managerGraduation2") as! String)
                        self.technicalManager2.text = skill
                    } else {
                        self.technicalManager2.text = " / "
                    }
                    
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.technicalExample1.text = example1
                    if (document.get("skillExample2") != nil) {
                        let skill = (document.get("skillExample2") as! String) + " / " + (document.get("improvementAndGain2") as! String)
                        self.technicalExample2.text = skill
                    } else {
                        self.technicalExample2.text = " / "
                    }
                    
                    
                    self.retrieveProfessionValue()
                    
                }
            }
        }
    }
    
    
    
    private func retrieveProfessionValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("professionSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let skill = (document.get("skill1") as! String)
                    self.profession1.text = skill
                    if (document.get("skill2") != nil) {
                        let skill = (document.get("skill2") as! String)
                        self.profession2.text = skill
                    } else {
                        self.profession2.text = " / "
                    }
                    if (document.get("skill3") != nil) {
                        let skill = (document.get("skill3") as! String)
                        self.profession3.text = skill
                    } else {
                        self.profession3.text = " / "
                    }
                    
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.professionEmployee1.text = employeeGraduation1
                    if (document.get("employeeGraduation2") != nil) {
                        let skill = (document.get("employeeGraduation2") as! String)
                        self.professionEmployee2.text = skill
                    } else {
                        self.professionEmployee2.text = " / "
                    }
                    if (document.get("employeeGraduation3") != nil) {
                        let skill = (document.get("employeeGraduation3") as! String)
                        self.professionEmployee3.text = skill
                    } else {
                        self.professionEmployee3.text = " / "
                    }
                    
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.professionManager1.text = managerGraduation1
                    if (document.get("managerGraduation2") != nil) {
                        let skill = (document.get("managerGraduation2") as! String)
                        self.professionManager2.text = skill
                    } else {
                        self.professionManager2.text = " / "
                    }
                    if (document.get("managerGraduation3") != nil) {
                        let skill = (document.get("managerGraduation3") as! String)
                        self.professionManager3.text = skill
                    } else {
                        self.professionManager3.text = " / "
                    }
                    
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.professionExample1.text = example1
                    if (document.get("skillExample2") != nil) {
                        let skill = (document.get("skillExample2") as! String) + " / " + (document.get("improvementAndGain2") as! String)
                        self.professionExample2.text = skill
                    } else {
                        self.professionExample2.text = " / "
                    }
                    if (document.get("skillExample23") != nil) {
                        let skill = (document.get("skillExample3") as! String) + " / " + (document.get("improvementAndGain3") as! String)
                        self.professionExample3.text = skill
                    } else {
                        self.professionExample3.text = " / "
                    }
                    
                    
                    self.retrieveFunctionalValue()
                    
                }
            }
        }
    }
    
    
    private func retrieveFunctionalValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("functionalSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let skill = (document.get("skill1") as! String)
                    self.functionnal1.text = skill
                    if (document.get("skill2") != nil) {
                        let skill = (document.get("skill2") as! String)
                        self.functionnal2.text = skill
                    } else {
                        self.functionnal2.text = " / "
                    }
                    
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.functionnalEmployee1.text = employeeGraduation1
                    if (document.get("employeeGraduation2") != nil) {
                        let skill = (document.get("employeeGraduation2") as! String)
                        self.functionnalEmployee2.text = skill
                    } else {
                        self.functionnalEmployee2.text = " / "
                    }
                    
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.functionnalManager1.text = managerGraduation1
                    if (document.get("managerGraduation2") != nil) {
                        let skill = (document.get("managerGraduation2") as! String)
                        self.functionnalManager2.text = skill
                    } else {
                        self.functionnalManager2.text = " / "
                    }
                    
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.functionnalExample1.text = example1
                    if (document.get("skillExample2") != nil) {
                        let skill = (document.get("skillExample2") as! String) + " / " + (document.get("improvementAndGain2") as! String)
                        self.functionnalExample2.text = skill
                    } else {
                        self.functionnalExample2.text = " / "
                    }
                    
                    
                    self.retrieveManagerialValue()
                    
                }
            }
        }
    }
    
    private func retrieveManagerialValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("managerialSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let skill = (document.get("skill1") as! String)
                    self.managerial1.text = skill
                    if (document.get("skill2") != nil) {
                        let skill = (document.get("skill2") as! String)
                        self.managerial2.text = skill
                    } else {
                        self.managerial2.text = " / "
                    }
                    
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.managerialEmployee1.text = employeeGraduation1
                    if (document.get("employeeGraduation2") != nil) {
                        let skill = (document.get("employeeGraduation2") as! String)
                        self.managerialEmployee2.text = skill
                    } else {
                        self.managerialEmployee2.text = " / "
                    }
                    
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.managerialManager1.text = managerGraduation1
                    if (document.get("managerGraduation2") != nil) {
                        let skill = (document.get("managerGraduation2") as! String)
                        self.managerialManager2.text = skill
                    } else {
                        self.managerialManager2.text = " / "
                    }
                    
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.managerialExample1.text = example1
                    if (document.get("skillExample2") != nil) {
                        let skill = (document.get("skillExample2") as! String) + " / " + (document.get("improvementAndGain2") as! String)
                        self.managerialExample2.text = skill
                    } else {
                        self.managerialExample2.text = " / "
                    }
                    
                    
                    self.retrieveAutonomousValue()
                    
                }
            }
        }
    }
    
    
    private func retrieveAutonomousValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("autonomySkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.autonomousEmployee.text = employeeGraduation1
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.autonomousManager.text = managerGraduation1
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.autonomousExample.text = example1
                    
                    self.retrieveAdaptabilityValue()
                    
                }
            }
        }
    }
    
    private func retrieveAdaptabilityValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("adaptabilitySkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.adaptabilityEmployee.text = employeeGraduation1
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.adaptabilityManager.text = managerGraduation1
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.adaptabilityExample.text = example1
                    
                    self.retrieveTeamWorkValue()
                    
                }
            }
        }
    }
    
    private func retrieveTeamWorkValue() {
           db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("teamWorkSkillEvaluation").getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                       self.teamWorkEmployee.text = employeeGraduation1
                       let managerGraduation1 = (document.get("managerGraduation1") as! String)
                       self.teamWorkManager.text = managerGraduation1
                       let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                       self.teamWorkExample.text = example1
                       
                       self.retrieveCreativityValue()
                       
                   }
               }
           }
       }
    
    private func retrieveCreativityValue() {
           db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("creativitySkillEvaluation").getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                       self.creativityEmployee.text = employeeGraduation1
                       let managerGraduation1 = (document.get("managerGraduation1") as! String)
                       self.creativityManager.text = managerGraduation1
                       let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                       self.creativityExample.text = example1
                       
                       self.retrieveCommunicationValue()
                       
                   }
               }
           }
       }
    
    
    private func retrieveCommunicationValue() {
           db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("communicationSkillEvaluation").getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                       self.communicationEmployee.text = employeeGraduation1
                       let managerGraduation1 = (document.get("managerGraduation1") as! String)
                       self.communicationManager.text = managerGraduation1
                       let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                       self.communicationExample.text = example1
                       
                       self.retrieveImplicationValue()
                       
                   }
               }
           }
       }
    
    private func retrieveImplicationValue() {
           db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("implicationSkillEvaluation").getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                       self.implicationEmployee.text = employeeGraduation1
                       let managerGraduation1 = (document.get("managerGraduation1") as! String)
                       self.implicationManager.text = managerGraduation1
                       let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                       self.implicationExample.text = example1
                       
                       self.retrieveRespectValue()
                       
                   }
               }
           }
       }
    
    private func retrieveRespectValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("respectSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.respectEmployee.text = employeeGraduation1
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.respectManager.text = managerGraduation1
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.respectExample.text = example1
                    
                    self.retrieveRigourValue()
                    
                }
            }
        }
    }
    
    private func retrieveRigourValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("rigourSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.rigourEmployee.text = employeeGraduation1
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.rigourManager.text = managerGraduation1
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.rigourExample.text = example1
                    
                    self.retrieveEnglishValue()
                    
                }
            }
        }
    }
    
    private func retrieveEnglishValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("englishSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.englishEmployee.text = employeeGraduation1
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.englishManager.text = managerGraduation1
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.englishExample.text = example1
                    
                    self.retrieveOtherLanguageValue()
                    
                }
            }
        }
    }
    
    private func retrieveOtherLanguageValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("othersSkillEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let employeeGraduation1 = (document.get("employeeGraduation1") as! String)
                    self.otherLanguageEmployee.text = employeeGraduation1
                    let managerGraduation1 = (document.get("managerGraduation1") as! String)
                    self.otherLanguageManager.text = managerGraduation1
                    let example1 = (document.get("skillExample1") as! String) + " / " + (document.get("improvementAndGain1") as! String)
                    self.otherLanguageExample.text = example1
                    
                    self.retrieveEvaluationValue()
                }
            }
        }
    }
    
    private func retrieveEvaluationValue() {
           db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("skillEvaluation").getDocuments() { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in querySnapshot!.documents {
                       let performance = (document.get("skillEvaluation") as! String)
                       
                       switch performance {
                       case "Expertise":
                           self.answerA.backgroundColor = UIColor.darkGray
                       case "Capacité Autonome":
                           self.answerB.backgroundColor = UIColor.darkGray
                       case "Capacité Partielle":
                           self.answerC.backgroundColor = UIColor.darkGray
                       case "Notion":
                           self.answerD.backgroundColor = UIColor.darkGray
                       default:
                           return
                       }
                    
                    self.performSegue(withIdentifier: "fifthPDF", sender: nil)

                       
                   
                   }
               }
           }
       }
  
}


