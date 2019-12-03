//
//  MailUtil.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 29/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import MessageUI

class MailUtil  {
    
    static func sendEmail(controller: UIViewController, mailComposeDelegate: MFMailComposeViewControllerDelegate, recipient: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            
            let body = StringValues.mailSubjectEmployee +
                AuthenticationUtil.employeeName + " " + AuthenticationUtil.employeeSurname
            let subject = StringValues.mailObject + AuthenticationUtil.employeeName + " " + AuthenticationUtil.employeeSurname
            
            mail.mailComposeDelegate = mailComposeDelegate
            mail.setToRecipients([recipient])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: true)
            
            controller.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    
    static func sendMailWithPdf(controller: UIViewController, mailComposeDelegate: MFMailComposeViewControllerDelegate, recipient: String) {
        if( MFMailComposeViewController.canSendMail()){
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = mailComposeDelegate
            
            //Set to recipients
            mailComposer.setToRecipients([recipient])
            
            //Set the subject
            mailComposer.setSubject("email with document pdf")
            
            //set mail body
            mailComposer.setMessageBody("This is what they sound like.", isHTML: true)
            
            let pdfName =  AuthenticationUtil.employeeName + "_" + AuthenticationUtil.employeeSurname + ".pdf"
            
            let pathPDF = "\(NSTemporaryDirectory())" + pdfName
            print("sendMailWithPdf pathPDF : \(pathPDF)")
            
            if let fileData = NSData(contentsOfFile: pathPDF) {
                print("File data loaded.")
                mailComposer.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: pdfName)
            }
            
            //this will compose and present mail to user
            controller.present(mailComposer, animated: true, completion: nil)
            
        }
        else {
            print("email is not supported")
        }
    }
    
}
