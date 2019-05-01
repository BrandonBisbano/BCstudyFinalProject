//
//  StudyUser.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/24/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class StudyUser {
    var email: String
    var displayName: String
    var phoneNumberString: String
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["email": email, "displayName": displayName, "phoneNumberString": phoneNumberString, "photoURL": photoURL, "documentID":  documentID]
    }
    
    init(email: String, displayName: String, phoneNumberString: String, photoURL: String, documentID: String) {
        self.email = email
        self.displayName = displayName
        self.phoneNumberString = phoneNumberString
        self.photoURL = photoURL
        self.documentID = documentID
    }
    
    convenience init(user: User) {
        self.init(email: user.email ?? "", displayName: user.displayName ?? "", phoneNumberString: "", photoURL: (user.photoURL != nil ? "\(user.photoURL!)" : ""), documentID: user.uid)
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let displayName = dictionary["displayName"] as! String? ?? ""
        let phoneNumberString = dictionary["phoneNumberString"] as! String? ?? ""
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        self.init(email: email, displayName: displayName, phoneNumberString: phoneNumberString, photoURL: photoURL, documentID: "")
    }
    
    func checkIfNewUser(documentID: String, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error: could not access document for user \(userRef.documentID).")
                return completed(false)
            }
            guard document?.exists == false else {
                print("^^^ The document for user \(self.documentID) already exists. No reason to create it.")
                return completed(false)
            }
            completed(true)
        }
    }
    
    func saveIfNewUser() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error: could not access document for user \(userRef.documentID).")
                return
            }
            guard document?.exists == false else {
                print("^^^ The document for user \(self.documentID) already exists. No reason to create it.")
                return
            }
            self.saveData()
        }
    }
    
    func saveData() {
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        db.collection("users").document(documentID).setData(dataToSave) { error in
            if let error = error {
                print("*** ERROR: \(error.localizedDescription), could not save data for \(self.documentID)")
            }
        }
    }
}
