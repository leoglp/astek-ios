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

    static func sendEmail(controller: UIViewController, mailComposeDelegate: MFMailComposeViewControllerDelegate , recipient: String) {
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

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}
