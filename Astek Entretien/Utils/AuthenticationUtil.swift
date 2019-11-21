//
//  AuthenticationUtil.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 14/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AuthenticationUtil {
    
    static var isManager: Bool = false
    static var employeeDocumentId: String = ""
    static var managerDocumentId: String = ""
    static var employeeName = ""
    static var employeeSurname = ""
    static var managerName = ""
    static var managerSurname = ""
    static var employeeMail = ""
    
    static let fbAuth = Auth.auth()
    
    static func signIn(controller: UIViewController, email: String, password: String) {
        fbAuth.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                UIUtil.showMessage(text: error.localizedDescription)
            }
            else if user != nil {
                
                let db = Firestore.firestore()
                db.collection("users").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if ((document.get("mail") as! String) == fbAuth.currentUser?.email ) {
                                if (document.get("profilFunction") as! String == "manager") {
                                    managerName = document.get("name")  as! String
                                    managerSurname = document.get("surname") as! String
                                    managerDocumentId = document.documentID
                                    isManager = true
                                    controller.performSegue(withIdentifier: "showManager", sender: nil)
                                } else {
                                    employeeDocumentId = document.documentID
                                    isManager = false
                                    employeeName = document.get("name") as! String
                                    employeeSurname = document.get("surname") as! String
                                    employeeMail = document.get("mail") as! String
                                    DatabaseUtil.readAndGoToPage(controller: controller)
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    
    static func createUser(email: String, password: String, controller: UIViewController) {
        UIUtil.showMessage(text: StringValues.profilCreation)
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                UIUtil.showMessage(text: error.localizedDescription)
            }
            else if user != nil {
                controller.performSegue(withIdentifier: "showFirstPage", sender: nil)
            }
        }
    }
    
    static func resetPassword(email: String, controller: UIViewController) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                UIUtil.showMessage(text: error!.localizedDescription)
            } else {
                UIUtil.showMessage(text: StringValues.resetMail)
                controller.performSegue(withIdentifier: "showFirstPage", sender: nil)
            }
        }
    }
}
