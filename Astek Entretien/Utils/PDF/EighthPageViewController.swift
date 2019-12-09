//
//  EighthPageViewController.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 06/12/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase
import PDFGenerator
import MessageUI

class EighthPageViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var pageController: UIViewController!
    
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var synthesisTitle: UILabel!
    @IBOutlet weak var synthesis: UILabel!

    @IBOutlet weak var decisionTitle: UILabel!
    @IBOutlet weak var decision: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        pageController = self
        
        PDFUtil.tabView.append(pageView)
        
        initText()
        
        retrieveValue()
    }
    
    
    private func initText() {
        synthesisTitle.underline()
        synthesis!.layer.borderWidth = 1
        
        decisionTitle.underline()
        decision!.layer.borderWidth = 1
    }
    
    private func generateMail() {
        let pdfName =  AuthenticationUtil.employeeName + "_" + AuthenticationUtil.employeeSurname + ".pdf"
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending(pdfName))
        
        // outputs as Data
        do {
            let data = try PDFGenerator.generated(by: PDFUtil.tabView)
            try data.write(to: dst, options: .atomic)
            MailUtil.sendMailWithPdf(controller: self, mailComposeDelegate: self, recipient: AuthenticationUtil.employeeMail)
        } catch (let error) {
            print(error)
        }
    }
    
    private func retrieveValue() {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection("synthesis").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let synthesis = "  " + (document.get("synthesis") as! String)
                    self.synthesis.text = synthesis
                    
                    self.generateMail()
                }
            }
        }
    }

}



// MARK: MFMailComposeViewControllerDelegate
extension EighthPageViewController : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        PDFUtil.tabView.removeAll()
        pageController.perform(#selector(presentExampleController), with: nil, afterDelay: 0)
    }
    
    @objc private func presentExampleController() {
        let exampleStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let exampleVC = exampleStoryboard.instantiateViewController(withIdentifier: "SynthesisView") as! SynthesisViewController
        present(exampleVC, animated: true)
    }
    
}



