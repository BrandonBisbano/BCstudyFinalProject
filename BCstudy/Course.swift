//
//  Course.swift
//  BCstudy
//
//  Created by Brandon Bisbano on 4/24/19.
//  Copyright © 2019 Brandon Bisbano. All rights reserved.
//

import Foundation
import Firebase

class Course {
    var courseName: String
    var courseID: String
    var professorName: String
    var documentUUID: String
    
    var dictionary: [String: Any] {
        return ["courseName": courseName, "courseID": courseID, "professorName": professorName, "documentUUID": documentUUID]
    }
    
    init(courseName: String, courseID: String, professorName: String, documentUUID: String) {
        self.courseName = courseName
        self.courseID = courseID
        self.professorName = professorName
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        self.init(courseName: "", courseID: "", professorName: "", documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let courseName = dictionary["courseName"] as! String? ?? ""
        let courseID = dictionary["courseID"] as! String? ?? ""
        let professorName = dictionary["professorName"] as! String? ?? ""
        let documentUUID = dictionary["documentUUID"] as! String? ?? ""
        self.init(courseName: courseName, courseID: courseID, professorName: professorName, documentUUID: documentUUID)
    }
    
    func saveCourseData(currentDocumentID: String, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let userUID = (Auth.auth().currentUser?.uid) else { // do you have a current user? if you do, let's get the userID.
            print("*** ERROR: Could not save data because we don't have a valid userUID.")
            return completed(false)
        }
        
        let dataToSave = self.dictionary

        var ref: DocumentReference? = nil // Firestore will creat a new ID for us
        ref = db.collection("users").document(currentDocumentID).collection("courses").addDocument(data: dataToSave) { (error) in
            if let error = error {
                print("ERROR: creating new document \(self.documentUUID) \(error.localizedDescription)")
                completed(false)
            } else { // It worked! Save the documentID in Spot’s documentID property
                print("^^^ New document created with ref ID \(ref?.documentID ?? "unknown").")
                self.documentUUID = ref!.documentID
                completed(true)
                print("documentUUID: \(self.documentUUID)")
            }
        }
    }
}
