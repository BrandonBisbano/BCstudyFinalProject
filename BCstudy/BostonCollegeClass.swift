//
//  BostonCollegeClass.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/28/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class BostonCollegeClass {
    var courseID: String
    var classmatesArray: [Classmate]
    
    var dictionary: [String: Any] {
        return ["courseID": courseID, "classmatesArray": classmatesArray]
    }
    
    init(courseID: String, classmatesArray: [Classmate]) {
        self.courseID = courseID
        self.classmatesArray = classmatesArray
    }
    
    convenience init() {
        self.init(courseID: "", classmatesArray: [Classmate]())
    }
    
    convenience init(dictionary: [String: Any]) {
        let courseID = dictionary["courseID"] as! String? ?? ""
        let classmatesArray = dictionary["classmatesArray"] as! [Classmate]? ?? [Classmate]()
        self.init(courseID: courseID, classmatesArray: classmatesArray)
    }
    
    func saveIfNewBostonCollegeClassAndSaveUserInClass(classDocumentID: String, classmate: Classmate, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        guard let userUID = (Auth.auth().currentUser?.uid) else { // do you have a current user? if you do, let's get the userID.
            print("*** ERROR: Could not save data because we don't have a valid userUID.")
            return completed(false)
        }
        let dataToSave = self.dictionary
        
        let userRef = db.collection("classes").document(classDocumentID)
        
        userRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error: could not access document for user \(userRef.documentID).")
                return
            }
            guard document?.exists == false else {
                print("^^^ The class \(classDocumentID) already exists. No reason to create it.")
                self.classmatesArray.append(classmate)
                print("New classmates array for class \(classDocumentID): \(self.classmatesArray)")
                return
            }
            self.saveData(classDocumentID: classDocumentID) { (success) in
                if success {
                    print("New Class Added!!! in BostonCollegeClass \(classDocumentID).")
                    self.classmatesArray.append(classmate)
                    print("New classmates array for class \(classDocumentID): \(self.classmatesArray)")
                    completed(true)
                } else {
                    print("Couldn't saved data for new class \(classDocumentID).")
                    completed(false)
                }
            }
        }
    }
    
    func saveData(classDocumentID: String, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave: [String: Any] = self.dictionary
        
        self.courseID = classDocumentID
        
        var ref: DocumentReference?
        db.collection("classes").document(classDocumentID).setData(dataToSave) { error in
            if let error = error {
                print("*** ERROR: \(error.localizedDescription), could not save data for class \(classDocumentID)")
                completed(false)
            } else {
                print("Success! saved data for new class \(classDocumentID) in BostonCollegeClass.")
                completed(true)
            }
        }
    }
    
}
