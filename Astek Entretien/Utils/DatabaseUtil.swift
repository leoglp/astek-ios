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
        var ref: DocumentReference? = nil
        ref = db.collection("users")
            .addDocument(data: valueToAdd) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
        }
    }
}
