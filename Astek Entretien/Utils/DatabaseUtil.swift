//
//  DatabaseUtil.swift
//  Astek Entretien
//
//  Created by Léo Guilpain on 18/11/2019.
//  Copyright © 2019 Astek. All rights reserved.
//

import UIKit
import Firebase

class DatabaseUtil {
    
    static let db = Firestore.firestore()
    
    static func createProfil(valueToAdd: [String: String]) {
        db.collection("users")
            .addDocument(data: valueToAdd) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                }
        }
    }
    
    static func retrieveMailAddress(name: String, surname: String, controller: UIViewController) {
        var emailAddress = ""
        db.collection("users").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                
                for document in querySnapshot!.documents {
                    var nameInsensitive = document.get("name") as! String
                    var surnameInsensitive = document.get("surname") as! String
                    nameInsensitive = nameInsensitive.lowercased()
                    surnameInsensitive = surnameInsensitive.lowercased()
                    
                    
                    if(nameInsensitive == name
                        && surnameInsensitive == surname) {
                        emailAddress = document.get("mail") as! String
                        AuthenticationUtil.employeeDocumentId = document.documentID
                    }
                }
                
                if(emailAddress != "") {
                    getNameAndSurname(controller: controller)
                } else {
                    UIUtil.showMessage(text: StringValues.errorNoPerson)
                }
            }
        }
    }
    
    static func readAndGoToPage(controller: UIViewController) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if((document.get("mail") as! String) == Auth.auth().currentUser?.email) {
                        let pageNumberString = (document.get("page") as! String)
                        let pageNumber = Int(pageNumberString)
                        UIUtil.goToPage(pageNumber: pageNumber!,controller: controller)
                    }
                }
            }
        }
    }
    
    
    private static func getNameAndSurname(controller: UIViewController) {
        let docRef = db.collection("users").document(AuthenticationUtil.employeeDocumentId)
        docRef.getDocument { (document, err) in
            if let document = document, document.exists {
                AuthenticationUtil.employeeName = document.get("name") as! String
                AuthenticationUtil.employeeSurname = document.get("surname") as! String
                AuthenticationUtil.employeeMail = document.get("mail") as! String
                UIUtil.goToPage(pageNumber: 1, controller: controller)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    static func updatePageValue(pageNumber: String) {
        let pageValue: [String: String]  = [
            "page" : pageNumber
        ]
        
        if(AuthenticationUtil.isManager){
            db.collection("users").document(AuthenticationUtil.managerDocumentId).updateData(pageValue)
        } else {
            db.collection("users").document(AuthenticationUtil.employeeDocumentId).updateData(pageValue)
        }
    }
    
    
    static func updateValueInDataBase(valueToUpdate: [String: String], collectionToUpdate: String , documentUpdateId: String) {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection(collectionToUpdate).document(documentUpdateId).updateData(valueToUpdate)
    }
    
    
    static func addValueInDataBase(valueToAdd: [String: String], collectionToCreate: String) {
        db.collection("users").document(AuthenticationUtil.employeeDocumentId).collection(collectionToCreate).addDocument(data: valueToAdd) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Collection \(collectionToCreate) added")
            }
        }
    }
}
