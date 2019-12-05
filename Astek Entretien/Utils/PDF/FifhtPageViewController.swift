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
import MessageUI

class FifthPageViewController: UIViewController {
    
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
        
    }
    
    
    private func generateMail() {
           let pdfName =  AuthenticationUtil.employeeName + "_" + AuthenticationUtil.employeeSurname + ".pdf"
           let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending(pdfName))
           
           // outputs as Data
           do {
               let data = try PDFGenerator.generated(by: PDFUtil.tabView)
               try data.write(to: dst, options: .atomic)
               MailUtil.sendMailWithPdf(controller: self, mailComposeDelegate: self, recipient: "leoguilpain36@gmail.com")
           } catch (let error) {
               print(error)
           }
       }
    
    private func retrieveFirstValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("futureTargetEvaluation").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var text = ""
                    let target1 = (document.get("target1") as! String)
                    text = "  1 - \(target1)"
                    self.firstLeftText.text = text
                    
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
                    
                    
                    
                    let result1 = (document.get("result1") as! String)
                    text = "  1 - \(result1)"
                    self.firstRightText.text = text
                    
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
                    
                     self.generateMail()
                    
                }
            }
        }
    }
    
    
}



// MARK: MFMailComposeViewControllerDelegate
extension FifthPageViewController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        pageController.perform(#selector(presentExampleController), with: nil, afterDelay: 0)
    }
    
    @objc private func presentExampleController() {
        let exampleStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let exampleVC = exampleStoryboard.instantiateViewController(withIdentifier: "SynthesisView") as! SynthesisViewController
        present(exampleVC, animated: true)
    }
    
}
