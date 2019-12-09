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
            print("email is not supported")
        }
    }
    
    
    static func sendMailWithPdf(controller: UIViewController, mailComposeDelegate: MFMailComposeViewControllerDelegate, recipient: String) {
        if( MFMailComposeViewController.canSendMail()){
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = mailComposeDelegate
            
            //Set to recipients
            mailComposer.setToRecipients([recipient])
            
            //Set the subject
            let subject = StringValues.mailObject + AuthenticationUtil.employeeName + " " + AuthenticationUtil.employeeSurname
            mailComposer.setSubject(subject)
            
            //set mail body
            let body = StringValues.mailSubjectManager +
                AuthenticationUtil.managerName + " " + AuthenticationUtil.managerSurname
            mailComposer.setMessageBody(body, isHTML: true)
            
            let pdfName =  AuthenticationUtil.employeeName + "_" + AuthenticationUtil.employeeSurname + ".pdf"
            
            let pathPDF = "\(NSTemporaryDirectory())" + pdfName
            
            if let fileData = NSData(contentsOfFile: pathPDF) {
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
